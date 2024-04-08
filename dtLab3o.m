% CLIPPING on audio signal
clear all
clc

fs = 44100;% Sampling frequency
n_bits = [4,6,8]; % Number of quantization bits
intervals = 50; % Number of intervals
[data,fs] = audioread('simpleMusic.mp3');

x = data(:,end);
x = x / max(abs(x));
[min0, max0] = bounds(x);

% Simulation for different n
snr = zeros(1, intervals);
adc_ranges = linspace(0.5, 2, intervals);

for j = 1:length(n_bits)
    n = n_bits(j);
    M = 2^n;

    for i = 1:intervals
        adc_range = adc_ranges(i);
        min = min0*adc_range;
        max = max0*adc_range;
        vin_range = max - min;
        delta = vin_range / M;
       snr(j,i) = c_channel0(x,delta,n,min,max);
   end

end

figure;
for j = 1:length(n_bits)
    plot(adc_ranges, 10*log10(snr(j,:)), 'LineWidth', 2, 'DisplayName', ['n = ', num2str(n_bits(j))]);
    hold on;
end

xlabel('ADC Range');
ylabel('SNR (dB)');
title('SNR vs. ADC Range');
legend('Location', 'best');
hold off;