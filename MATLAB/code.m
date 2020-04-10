%% Cargando la se�al 100m y se�al 04015m del MIT-BIH Arrhythmia Database

% Cargado de la se�al de Bradicardia

load('100m.mat')

% En el archivo 100m.info se especifican que hay 2 se�ales capturadas
% en el archivo 100m.mat con una frecuencia de muestreo de 360 Hz y
% una ganancia de 200.
signal_MLII = val(1,:)/200;
signal_V5 = val(2,:)/200;
fs_b = 360;
N_b = length(signal_V5);
time_vector_b = 1/fs_b : 1/fs_b : (N_b*1/fs_b);

% Cargado de la se�al de Fibrilaci�n

load('04015m.mat')

% En el archivo 100m.info se especifican que hay 2 se�ales capturadas
% en el archivo 100m.mat con una frecuencia de muestreo de 250 Hz y
% una ganancia de 200.
signal_ECG1 = val(1,:)/200;
signal_ECG2 = val(2,:)/200;
fs_f = 250;
N_f = length(signal_ECG2);
time_vector_f = 1/fs_f : 1/fs_f : (N_f*1/fs_f);

%% Caracterizando la se�al 100m mediante FFT

%Graficando la se�al original
figure(1)
subplot(2,1,1)
plot(time_vector_b,signal_V5)
legend('Se�al V5')
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('Se�al 100m - 60 segundos')

%Utilizando FT y PSD para realizar una caracterizaci�n del comportamiento en
%frecuencia de la se�al
x = fft(signal_V5);
Nx = length(x);
%Calculando potencia
Px = (abs(x).^2)/(Nx*fs_b);
f = (0:N_b-1)'*fs_b/Nx;
subplot(2,1,2)
x1 = f(1:floor(Nx/2)); %Magintud
y1 = 10*log(Px(1:floor(Nx/2))); %Potencia
plot(x1,y1)
title('Caracterizaci�n del ruido')
xlabel('F (Hz)')
ylabel('Potencia')
hold on
[peaks,loc] = findpeaks(y1,'MinPeakDistance',1000);
plot(f(loc),peaks,'or')

%% Dise�ando el filtro para la eliminaci�n de ruido de baja frecuencia

B = fir1(10,(1/(fs_b/2)));
output = filtfilt(B,1,signal_V5);
figure(2)
subplot(2,1,1)
plot(time_vector_b,signal_V5)
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
legend('Se�al V5 Original')
title('Eliminando ruido de 60 Hz')
subplot(2,1,2)
plot(time_vector_b, output)
legend('Se�al V5 filtrada con filtro FIR m�todo de ventana')
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
