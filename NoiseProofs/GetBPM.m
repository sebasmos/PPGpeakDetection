function BPM = GetBPM(name)
    bpms=load(name);
    BPM= bpms.BPM0;
end