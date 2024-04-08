function [snr] = c_channel(x,delta,nbits,min,max)

partition = [min+delta: delta : max-delta];
codeBook = [min+delta/2:delta:max];
[Indexes,Quants] = quantiz(x,partition,codeBook);
qError = x-Quants;
y1 = var(qError);
y2 = var(x);
snr = y2/y1;

end

