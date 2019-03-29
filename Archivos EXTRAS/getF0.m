function [F0,strength,T_ind,wflag] = getF0(y,Fs,time_step,min_pitch,max_pitch,max_no_cand,sil_thresh,voicing_thresh,octave_cost,jump_cost,voic_unv_cost);
%
% Finds the fundamental frequency contour (in Hz.) The output contains kmax 
% frames, where kmax = floor((length(x) - winoverlap)/(winlength-winoverlap))
% and winlength is the length of the analysis frame chosen to be the three 
% times the minimum period (i.e.; winlength = 3*Fs/min_pitch). The overlap 
% winoverlap is winlength-winstep = winlength-time_step*Fs.
% The algorithm is largely based on the one described in "Accurate Short-Term
% Analysis of the Fundamental Frequency and the Harmonics-to-Noise Ratio of a
% Sampled Sound," P. Boersma, IFA Proceedings, (17), 1993.
%
% Usage: [F0,strength,T_ind,wflag] = getF0(x,Fs,time_step,min_pitch,max_pitch,
%                                    max_no_cand,sil_thresh,voicing_thresh,
%                                    octave_cost,jump_cost,voic_unv_cost);
%
%	        x: Input signal
%              Fs: Sampling frequency
%       time_step: Time step (in secs.) between adjacent analysis frames. 
%                  (Default is 0.01 secs.)
%       min_pitch: Minimum pitch. Candidates below this threshold are not 
%                  considered. (Default is 75 Hz.)
%       max_pitch: Maximum pitch. Candidates above this threshold are not
%                  considered. (Default is 600 Hz.)
%     max_no_cand: Maximum number of candidates considered at every frame
%                  (Default is 15)
%      sil_thresh:  
%  voicing_thresh: Thresholds used to determine strength of unvoiced
%                  candidate. Must be between 0 and 1. 
%                  (Defaults are 0.03 and 0.45, respectively)
%     octave_cost: Parameter to favor lower vs. higher fund. freqs. when
%                  assigning strength to voiced candidates.
%                  (Default is 0.01)
%       jump_cost:   
%   voic_unv_cost: Parameters to penalize octave jumps and voiced-to-unvoiced
%                  transitions between adjacent frames. 
%                  (Defaults are 0.35 and 0.2, respectively)
%
% Use [] to skip an argument and assign it to its default value.
%
%              F0: 1xkmax vector containing fundamental frequency estimates.
%                  Unvoiced estimates are encoded as 0.
%        strength: 1Xkmax vector containing relative strength of selected 
%	           F0 candidate
%           T_ind: kmaxX2 vector contaning the indices of the first and last
%                  speech samples used in the analysis of each frame
%           wflag: warning flag (1 if a warning was issued. 0 otherwise)
%
%

%
% Copyright (C) 2006  Raul Fernandez | galt@media.mit.edu
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You can obtain a copy of the GNU General Public License from
% http://www.gnu.org/licenses/gpl.txt or by writing to 
%   The Free Software Foundation, Inc., 
%   51 Franklin Street, Fifth Floor, 
%   Boston, MA  02110-1301, USA.
%


y=y(:)';

% Define global parameters
na = nargin;

if (na < 3) || isempty(time_step);  time_step = 0.01; end	%Time step in secs.
if (na < 4) || isempty(min_pitch);  min_pitch = 75;   end	%Min. pitch in Hz.
if (na < 5) || isempty(max_pitch);  max_pitch = 600;  end	%Max. pitch in Hz.
if (na < 6) || isempty(max_no_cand); max_no_cand = 15; end       %Max. number of candidates
if (na < 7) || isempty(sil_thresh); sil_thresh = 0.03; end	%Silence threshold
if (na < 8) || isempty(voicing_thresh); voicing_thresh = 0.45; end %Voicing Threshold
if (na < 9) || isempty(octave_cost); octave_cost = 0.01; end	%Octave Cost
if (na < 10) || isempty(jump_cost); jump_cost = 0.35; end	%Jump Cost
if (na < 11) || isempty(voic_unv_cost); voic_unv_cost = 0.2; end	%Voice-Unvoice Cost 


% Preprocess entire signal. Low pass filter with cutoff of 4kHz
if Fs > 8000
  wn = 8000/Fs;
  N = 10;
  [b,a] = butter(N,wn);
  x = filter(b,a,y);
else
  x = y;
end

gap = max(abs(x));
win_length = ceil(3*Fs/min_pitch);	% Window length large enough to accommodate 3 periods
win_step = round(time_step*Fs);
L = length(x);
x = x(:)';

wflag = 0;
if (L < win_length)
 warning('Segment too small. Replicating segment to improve accuracy');
 wflag = 1;
 multfactor = ceil(win_length/L);
 x = kron(ones(1,multfactor),x);
 L = length(x);
end

% Find norm. autocorrelation of Gaussian window
t = [1:win_length];
w = (exp(-12*((t/win_length)-0.5).^2)-exp(-12))./(1-exp(-12));
w = [w zeros(1,ceil(win_length/2))];
l2 = 2^ceil(log2(length(w)));
W = fft(w,l2);
WW = abs(W).^2;
rw = real(ifft(WW));
rw = rw/max(rw);

% Process short-time
delta2 = floor(Fs/min_pitch);
delta1 = ceil(Fs/max_pitch);
delta_diff = round(delta1/2);

kmax = floor(1+(L-win_length)/win_step);
%fprintf('kmax is %f', kmax);
C = [];
for k=1:kmax
  seg = x((k-1)*win_step+1:(k-1)*win_step+win_length);
  if (max(abs(seg)) <1e-20) % This is a rare case when the signal is a numerical zero throughout
    C(1,k).F = [0];
    C(1,k).R = [voicing_thresh];
    T_ind(k,:) = [(k-1)*win_step+1 (k-1)*win_step+win_length];
    continue;
  end
  T_ind(k,:) = [(k-1)*win_step+1 (k-1)*win_step+win_length];
  lap = max(abs(seg));
  seg = (seg - mean(seg));
  seg = [seg zeros(1,ceil(win_length/2))];
  seg = seg .* w;
  X_seg = fft(seg,l2);
  XX_seg = abs(X_seg).^2;
  ra = real(ifft(XX_seg));
  ra = ra/max(ra);
  ran = ra ./ rw;
  ranflpd = [ran(l2/2+1:end) ran(1:l2/2)];

  % Find "roughly" the locations and values of maxima by peakpicking
  [taus,r] = pickpeak(ran(delta1:delta2),max_no_cand,delta_diff);

  % Get rid of non-found candidates (shrink the zero indices)
  zero_ind = find(taus == 0);
  if ~isempty(zero_ind)
     taus(zero_ind) = [];
     r(zero_ind) = [];
  end
  % Get rid of peaks with negative values
  neg_ind = find(r < 0);
  if ~isempty(neg_ind)
     r(neg_ind) = [];
     taus(neg_ind) = [];
  end
  taus = taus+delta1-1; 	% Add the offset that pickpeak skips at the beginning

  %Refine locations and values of maxima by interpolation
  for ck=1:length(taus)  % Interpolate each of the candidates
    %N = min(500,floor(0.5*win_length-taus(ck)));
    N=10;  % Try this first; it's faster
    % Create grid (we may need to interpolate over negative lags)
    T = taus(ck);
    startl = T-N; x1 = [startl:T-1]; y1 = ranflpd(0.5*l2-1+(startl:T-1));
    endr = T+N;     x2 = [T+1:endr]; y2 = ran(T+1:endr);
    xx = [x1 T x2]; yy = [y1 ran(T) y2];
    testgrid=[T-1:0.01:T+1];
    interpran=spline(xx,yy,testgrid);
    [RR(ck,1),maxind] = max(interpran);
    TT(ck,1) = testgrid(maxind);
    if (TT(ck,1) > delta2); TT(ck,1) = delta2; end %Ensure that limits are respected 
    if (TT(ck,1) < delta1); TT(ck,1) = delta1; end %after interpolation
  end 

  Rvcd = RR - octave_cost*(log2(min_pitch*TT));   % Strength of voiced candidates
  Ro = voicing_thresh + max(0,2-(lap*(1+voicing_thresh)/(sil_thresh*gap)));
  C(1,k).F = [0; Fs./TT];
  C(1,k).R = [Ro; Rvcd];
end

%%%% Dynamic programming for smoothing 
Delta = {};
Psi = {};
Delta{1,1} = -C(1,1).R;
Psi{1,1} = 0*C(1,1).R;
for k=2:kmax
   A = transcost(C(1,k-1).F,C(1,k).F,voic_unv_cost,jump_cost);
   [minval,minarg] = min(Delta{1,k-1}*ones(1,size(A,2))+A,[],1);
   Delta{1,k} = minval' - C(1,k).R;
   Psi{1,k} = minarg;
   %pause
end
% Backtracking
[valstar,mstar(kmax)] = min(Delta{1,kmax}); 
F0(kmax) = C(1,kmax).F(mstar(kmax));
strength(kmax) = C(1,kmax).R(mstar(kmax));
for kk=kmax-1:-1:1
  mstar(kk) = Psi{1,kk+1}(mstar(kk+1));
  F0(kk) = C(1,kk).F(mstar(kk));
  strength(kk) = C(1,kk).R(mstar(kk));
end


function f1f2cost = transcost(F1,F2,voic_unv_cost,jump_cost)
%
% This subfunction calculates the cost associated with a transition from 
% F1 to F2 given VoicedUnvoicedCost, and OctaveJumpCost parameters. If
% F1 and F2 are Nx1 and Mx1 column vectors respectively, f2f2cost is an
% NxM matrix with the (i,j) entry containing the cost of transitioning
% from F1(i) to F2(j)
%

for n=1:length(F1)
   for m=1:length(F2)
      f1= F1(n); f2=F2(m);
      if (f1==0) & (f2==0) f1f2cost(n,m) = 0;
      elseif (f1~=0) & (f2~=0) f1f2cost(n,m) = jump_cost*abs(log2(f1/f2));
      else f1f2cost(n,m) = voic_unv_cost;
      end
   end
end

function  [loc,val] = pickpeak(spec,npicks,rdiff)
%PICKPEAK Picks peaks
% [loc,val] = pickpeak(spec,npicks,rdiff)
%       spec   - data vector or matrix
%       npicks - number of peaks desired              [default = 2]
%       rdiff  - minimum spacing between picked peaks [default = 5]
%       loc    - vector of locations (indices) of the picked peaks
%       val    - vector corresponding values
%       A 0 in location (i,j) of array loc (or a NaN in array val)
%       indicates that the j-th data vector has less than i peaks
%       with a separation of rdiff or more.

%  Copyright (c) 1991-1999 by United Signals & Systems, Inc. and The Mathworks, Inc. All Rights Reserved.
%       $Revision: 1.4 $
%  A. Swami Jan 20, 1995.

%     RESTRICTED RIGHTS LEGEND
% Use, duplication, or disclosure by the Government is subject to
% restrictions as set forth in subparagraph (c) (1) (ii) of the
% Rights in Technical Data and Computer Software clause of DFARS
% 252.227-7013.
% Manufacturer: United Signals & Systems, Inc., P.O. Box 2374,
% Culver City, California 90231.
%
%  This material may be reproduced by or for the U.S. Government pursuant
%  to the copyright license under the clause at DFARS 252.227-7013.
% ---- parameter checks  -------------------------------------------

if (exist('rdiff') ~= 1)  rdiff =  5;                  end
if (exist('npicks') ~= 1) npicks = 2;                  end

% ---- convert row vectors to col vectors  -------------------------

[mrows,ncols]  = size(spec);
if (mrows==1) mrows=ncols; ncols=1; spec = spec(:);   end

% ---- edit out NaNs and Infs ---------------------------------------

good = isfinite(spec);
rmin = min(spec(good)) - 1;
bad  = ~isfinite(spec);
spec(bad) = rmin;


% ---- find a peak, zero out the data around the peak, and repeat

val =  ones(npicks,ncols) * NaN ;
loc =  zeros(npicks,ncols) ;

for k=1:ncols
                                           % Find all local peaks:
    dx = diff([rmin; spec(:,k); rmin]);    % for a local peak at either end
    lp = find(dx(1:mrows)   >= 0 ...
            & dx(2:mrows+1) <=0);          % peak locations
    vp = spec(lp,k);                       % peak values

    for p=1:npicks
       [v,l] = max(vp);                   % find current maximum
       val(p,k) = v;  loc(p,k) = lp(l);   % save value and location

       ind = find(abs(lp(l)-lp) > rdiff);  % find peaks which are far away

       if (isempty(ind))
           break                           % no more local peaks to pick
       end
       vp  = vp(ind);                      % shrink peak value array
       lp  = lp(ind);                      % shrink peak location array
    end
end

