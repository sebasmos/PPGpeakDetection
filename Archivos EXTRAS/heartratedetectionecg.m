%% HeartRate Detection alg using ECG Signals
% La señal cuenta con 3.7 e 4 
% uncomment for octave under windows
% 
% h = fir1(1000,1/1000*2,'high');
% %% filter out DC
% 
% 
% h = fir1(1000,1/125*2,'high');
% 
% % filter out DC
% %figure(1)
% y_filt=filter(h,1,s2Norm);
% %plot(y_filt);
% 
% % square it
% detsq = y_filt .^ 2;
% figure(2)
% plot(detsq),grid on
% % % thresholded output
%  detthres = zeros(length(detsq),1);
% % 
% % % let's detect the momentary heart rate in beats per min
%  last=0;
%  upflag=0;
%  pulse=zeros(length(detsq),1);
%  p=0;
%  
%  for i = 1:length(detsq)
%     if (detsq(i) > 0.1)
%         if (upflag == 0)
%             if (last > 0)
%                 t = i - last;
%                 p = 1000/t;
%             end
%             last = i;
%         end
%         upflag = 10;
%     else
%         if (upflag>0)
%             upflag = upflag - 1;
%         end
%     end
%     pulse(i)=p;
% end
% % 
% % % plot it
% figure(3)
% plot (pulse);
% aux2 = 1;
% for j=1:length(pulse)-1
%     if(pulse(j)~= pulse(j+1))
%         aux2 = aux2+1;
%     end
% e