clc;
% clear all;
close all;
y=nanmean(EEG_signals{1,1}(5,:,:),3);

Yfourier = fft(y);                               % Compute DFT of x
m_y = abs(Yfourier);                               % Magnitude
Yfourier(m_y<1e-6) = 0;
p_y = unwrap(angle(Yfourier));                     % Phase

f = (0:length(Yfourier)-1)*100/length(Yfourier);        % Frequency vector

plot(f,m_y)
ylabel('Magnitude')
xlabel('Freqeuncy (Hz)')
ylim([0 600])

periodogram(y)