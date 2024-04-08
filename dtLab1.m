% VALIDATION AGAINST THEORY
clear all
clc

pe_range = logspace(-12,-1,100); % Range of pe
pe_range_sim = logspace(-12,-1,12); % Range of pe sim
fs = 44100;
n_bits = [4,6,8]; % Number of quantization bits

x = rand(1,10^6)*2-1;% Random siganl
[min, max] = bounds(x);
vin_range = max - min;
snr_simulated = zeros(length(n_bits),length(pe_range_sim));
snr_theoretical = zeros(length(n_bits),length(pe_range));

% PDF&PSD
figure(1)
histogram(x,20)

l = length(x);
xdft = fft(x);
xdft = xdft(1:l/2+1);
psdx = (1/(fs*l)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

% Plot PDF,PSD
figure(2)
plot(freq,pow2db(psdx))
grid on
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")

% Simulation for different n


for j = 1:length(n_bits)
    n = n_bits(j);
    M = 2^n;
    delta = vin_range / M;
    snr_theoretical(j,:) = M^2./(1+4*(M^2-1)*pe_range);

    for i = 1:length(pe_range_sim)
        snr_simulated(j,i) = simulate_channel(x, delta, n, pe_range_sim(i),min,max);
    end

end

% Plot snr vs pe for different n 
figure;
for j = 1:length(n_bits)
    semilogx(pe_range_sim, 10*log10(snr_simulated(j,:)), 'bo', 'LineWidth', 1); 
    hold on;
end

for j = 1:length(n_bits)
    semilogx(pe_range, 10*log10(snr_theoretical(j,:)), '-', 'LineWidth', 2);
    hold on;
end

title('SNR vs Error Probability');
xlabel('Pe');
ylabel('SNR(dB)');
legend('Simulated (n = 4)', 'Simulated (n = 6)', 'Simulated (n = 8)','Theoretical (n = 4)', 'Theoretical (n = 6)', 'Theoretical (n = 8)');
hold off;