%function BPM = GetBPM(name)
% name: Name of the dataset
function BPM = GetBPM(name)
    bpms=load(name);
    BPM= bpms.BPM0;
end