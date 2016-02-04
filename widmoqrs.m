function widmoqrs()

%badany sygna³
load('niebieski.mat')
a=[M(:,2)];
figure(1);
plot(a);

%widmo badanego sygna³u
widmo=fft(a);
n = length(widmo);
power = abs(widmo(1:floor(n/2))).^2;
nyquist = 1/2;
freq = ((1:n/2)/(n/2)*nyquist)*250;
figure(2);
plot(freq,power)
xlabel('Czêstotliwoœæ [Hz]'); ylabel('Amplituda');

%filtracja
b = [1 0.001];
c = 100000;
y = abs(filter(c,b,a));
figure(3);
plot(y);

%usuwanie niskich czêstotliwoœci
widmo_2=fft(y);
widmo_2(1 : round(length(widmo_2)*5/250))=0;
widmo_2(end - round(length(widmo_2)*5/250) : end)=0;
sygnal=real(ifft(widmo_2));
figure(5);
plot(sygnal);

%filtr dolnoprzepustowy 
filtr()
z=filter(b,1,sygnal); 
figure(6);
plot(z);
xlabel('Próbki'); 
ylabel('Napiêcie [mV]');

%skrócenie sygna³u
for i=1:700    %d³ugoœæ
    skrocsygnal(i) = sygnal(i);
end

threshold = 2*10^4; %wartoœæ graniczna

%zespó³ QRS
[~,locs_Rwave] = findpeaks(skrocsygnal,'MinPeakHeight',threshold,'MinPeakDistance',120);
sygnal_odwrocony = -skrocsygnal;
[~,locs_Swave] = findpeaks(sygnal_odwrocony,'MinPeakHeight',threshold,'MinPeakDistance',120);
[~,min_locs] = findpeaks(sygnal_odwrocony,'MinPeakDistance',10);
locs_Qwave = min_locs(sygnal_odwrocony(min_locs)>1.14*10^4 & sygnal_odwrocony(min_locs)<2*10^4);

%wykryte zespo³y QRS na wykresie
figure(7)
hold on
plot(skrocsygnal);
plot(locs_Qwave,skrocsygnal(locs_Qwave),'p','MarkerFaceColor','g');
plot(locs_Rwave,skrocsygnal(locs_Rwave),'s','MarkerFaceColor','r');
plot(locs_Swave,skrocsygnal(locs_Swave),'v','MarkerFaceColor','b');
grid on
title('Zespo³y QRS')
xlabel('Próbki'); ylabel('Napiêcie [mV]')
legend('Sygna³ EKG','S','R','Q');

end