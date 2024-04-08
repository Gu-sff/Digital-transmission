function [snrM] = simulate_channelM(x,delta,nbits,pe,min,max)

partition = [min+delta: delta : max-delta];
codeBook = [min+delta/2:delta:max];
[Indexes,Quants] = quantiz(x,partition,codeBook);
qError = x-Quants.';
y1 = rms(qError);
y2 = rms(x);
snrQuan = y2/y1;

%Encoding
bits_tx= de2bi(Indexes,nbits);

%BSC
bits_rx= bsc(bits_tx,pe);

%Decoder
Indexes_Out= bi2de(bits_rx);
decoded_samples = codeBook(Indexes_Out+1);
bErr = x-decoded_samples.';
snrBsc = var(x)/var(bErr);

total_error = bErr;
snrM = var(x)/var(total_error);
end
