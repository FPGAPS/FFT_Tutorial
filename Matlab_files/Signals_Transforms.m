clear all
close all
clc
%%

% Define parameters
fs = 1000;  % Sampling frequency (Hz)
t = -1:1/fs:1;  % Time vector from -1 to 1 second with step 1/fs
N = length(t); % Number of samples
f = (-N/2:N/2-1)*(fs/N); % Frequency vector for FFT
%%
% Generate signals
complex_exp = (exp(2*pi*1j*t));  % Real part of exp(jt)

% Compute FFTs
fft_complex_exp = fftshift(abs(fft(complex_exp)));

% Display real part of exp(jt)
figure;
plot(t, real(complex_exp), 'b', 'LineWidth', 1.5);
grid on;
title('Real Part of exp(jt)');
xlabel('Time (s)');
ylabel('Amplitude');

% Display FFT of real part of exp(jt)
figure;
plot(f, fft_complex_exp, 'b', 'LineWidth', 1.5);
grid on;
title('FFT of  of exp(jt)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-20 20])
%%
sinc_wave = sinc(5*t);  % Sinc function

% Display sinc function
figure;
plot(t, sinc_wave, 'r', 'LineWidth', 1.5);
grid on;
title('Sinc Function');
xlabel('Time (s)');
ylabel('Amplitude');
fft_sinc_wave = fftshift(abs(fft(sinc_wave)));

% Display FFT of sinc function
figure;
plot(f, fft_sinc_wave, 'r', 'LineWidth', 1.5);
grid on;
title('FFT of Sinc Function');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-20 20])
%%
rect_wave = double(abs(t) <= 0.2);  % Rectangular pulse centered at zero
% Display rectangular pulse
figure;
plot(t, rect_wave, 'g', 'LineWidth', 1.5);
grid on;
title('Rectangular Pulse');
xlabel('Time (s)');
ylabel('Amplitude');



fft_rect_wave = fftshift(abs(fft(rect_wave)));
% Display FFT of rectangular pulse
figure;
plot(f, fft_rect_wave, 'g', 'LineWidth', 1.5);
grid on;
title('FFT of Rectangular Pulse');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-20 20])