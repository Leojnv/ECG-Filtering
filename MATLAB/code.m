%% Cargando las se�ales de ECG
% Bradicardia: 100m del MIT-BIH Arrhythmia Database
% Fibrilaci�n: 04015m del MIT-BIH Atrial Fibrillation Database

% Bradicardia
    % Cargado de la se�al de Bradicardia
    load('100m.mat')
    % En el archivo 100m.info se especifican que hay 2 se�ales capturadas
    % en el archivo 100m.mat con una frecuencia de muestreo de 360 Hz y
    % una ganancia de 200.
    signal_MLII = val(1,:)/200;
    signal_V5 = val(2,:)/200; % Se analizar� esta se�al
    fs_b = 360;
    N_b = length(signal_V5);
    time_vector_b = 1/fs_b : 1/fs_b : (N_b*1/fs_b);

% Fibrilaci�n
    % Cargado de la se�al de Fibrilaci�n
    load('04015m.mat')
    % En el archivo 100m.info se especifican que hay 2 se�ales capturadas
    % en el archivo 100m.mat con una frecuencia de muestreo de 250 Hz y
    % una ganancia de 200.
    signal_ECG1 = val(1,:)/200;
    signal_ECG2 = val(2,:)/200; % Se analizar� esta se�al
    fs_f = 250;
    N_f = length(signal_ECG2);
    time_vector_f = 1/fs_f : 1/fs_f : (N_f*1/fs_f);

%% Caracterizando las se�ales mediante FFT para identificar los ruidos
    
    figure(1)
% Caracterizaci�n Bradicardia
    % Graficando la se�al original
    subplot(2,2,1)
    plot(time_vector_b,signal_V5)
    legend('Se�al V5 - Bradicardia')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    title('Se�al 100m - 60 segundos')

    %Utilizando FT y PSD para realizar una caracterizaci�n del comportamiento en
    %frecuencia de la se�al
    x = fft(signal_V5);
    Nx = length(x);
    %Calculando potencia
    Px = (abs(x).^2)/(Nx*fs_b);
    fx = (0:N_b-1)'*fs_b/Nx;
    subplot(2,2,3)
    x_x = fx(1:floor(Nx/2));                     %Magnitud
    x_y = 10*log(Px(1:floor(Nx/2)));             %Potencia
    plot(x_x,x_y)
    title('Caracterizaci�n de la se�al')
    xlabel('F (Hz)')
    ylabel('Potencia')
    hold on
    [peaks,loc] = findpeaks(x_y,'MinPeakDistance',1000);
    plot(fx(loc),peaks,'or')
    
% Caracterizaci�n Fibrilaci�n
    % Graficando la se�al original
    subplot(2,2,2)
    plot(time_vector_f,signal_ECG2)
    legend('Se�al ECG2 - Fibrilaci�n')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    title('Se�al 04015m - 60 segundos')

    %Utilizando FT y PSD para realizar una caracterizaci�n del comportamiento en
    %frecuencia de la se�al
    y = fft(signal_ECG2);
    Ny = length(y);
    %Calculando potencia
    Py = (abs(y).^2)/(Ny*fs_f);
    fy = (0:N_f-1)'*fs_f/Ny;
    subplot(2,2,4)
    y_x = fy(1:floor(Ny/2));                     %Magnitud
    y_y = 10*log(Py(1:floor(Ny/2)));             %Potencia
    plot(y_x,y_y)
    title('Caracterizaci�n de la se�al')
    xlabel('F (Hz)')
    ylabel('Potencia')
    hold on
    [peaks,loc] = findpeaks(y_y,'MinPeakDistance',1000);
    plot(fy(loc),peaks,'or')

%% Dise�ando y aplicando el filtro pasa bajo para la eliminaci�n de ruido de alta frecuencia

% Dise�o del filtro
    B = fir1(10,(1/(fs_b/2)), 'low');
    
    figure(2)
% Bradicardia
    output_b = filtfilt(B,1,signal_V5); 
    subplot(2,2,1)
    plot(time_vector_b,signal_V5)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al V5 Original')
    title('Antes de eliminar ruido de alta frecuencia')
    subplot(2,2,3)
    plot(time_vector_b, output_b)
    legend('Se�al V5 filtro pasa bajo')
    title('Luego de eliminar ruido de alta frecuencia')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')

% Fibrilaci�n    
    output_f = filtfilt(B,1,signal_ECG2); 
    subplot(2,2,2)
    plot(time_vector_f,signal_ECG2)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al ECG2 Original')
    title('Antes de eliminar ruido de alta frecuencia')
    subplot(2,2,4)
    plot(time_vector_f, output_f)
    legend('Se�al ECG2 filtro pasa bajo')
    title('Luego de eliminar ruido de alta frecuencia')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')

%% Dise�ando y aplicando el filtro tipo peine para la eliminaci�n de los arm�nicos de 60 hz

% Dise�o del filtro tipo peine
    N = 6;
    M = 60;
    b = zeros(1, N*M);
    b(1:N:end) = -1/M;
    b(1) = 1 - 1/M;
    
    figure(3)
% Bradicardia
    output_comb_b = filter(b,1,output_b);
    subplot(2,2,1)
    plot(time_vector_b,output_b)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al V5 filtro pasa bajo')
    title('Antes de eliminar ruido estructurado 60 hz')
    subplot(2,2,3)
    plot(time_vector_b, output_comb_b)
    legend('Se�al V5 filtro pasa bajo y tipo peine')
    title('Luego de eliminar ruido estructurado 60 hz')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    
% Fibrilaci�n
    output_comb_f = filter(b,1,output_f);
    subplot(2,2,2)
    plot(time_vector_f,output_f)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al ECG2 filtro pasa bajo')
    title('Antes de eliminar ruido estructurado 60 hz')
    subplot(2,2,4)
    plot(time_vector_f, output_comb_f)
    legend('Se�al ECG2 filtro pasa bajo y tipo peine')
    title('Luego de eliminar ruido estructurado 60 hz')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')

%% Dise�ando y aplicando el filtro pasa alto para eliminaci�n de ruido de baja frecuencia

% Dise�o del filtro
    B = fir1(10,(1/(fs_b/2)), 'high');
   
    figure(4)
% Bradicardia
    output_final_b = filtfilt(B,1,output_comb_b); 
    subplot(2,2,1)
    plot(time_vector_b,output_comb_b)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al V5 filtro pasa bajo y tipo peine')
    title('Antes de eliminar ruido de baja frecuencia')
    subplot(2,2,3)
    plot(time_vector_b, output_final_b)
    legend('Se�al V5 filtro pasa bajo, tipo peine y pasa alto')
    title('Luego de eliminar ruido de baja frecuencia')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')

% Fibrilaci�n
    output_final_f = filtfilt(B,1,output_comb_f); 
    subplot(2,2,2)
    plot(time_vector_f,output_comb_f)
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    legend('Se�al ECG2 filtro pasa bajo y tipo peine')
    title('Antes de eliminar ruido de baja frecuencia')
    subplot(2,2,4)
    plot(time_vector_f, output_final_f)
    legend('Se�al ECG2 filtro pasa bajo, tipo peine y pasa alto')
    title('Luego de eliminar ruido de baja frecuencia')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')

%% Caracterizando las se�ales filtradas mediante FFT

   figure(5)
% Caracterizaci�n Bradicardia
    % Graficando la se�al filtrada
    subplot(2,2,1)
    plot(time_vector_b,output_final_b)
    legend('Se�al V5 - Bradicardia - Filtrada')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    title('Se�al 100m - 60 segundos')

    %Utilizando FT y PSD para realizar una caracterizaci�n del comportamiento en
    %frecuencia de la se�al
    x = fft(output_final_b);
    Nx = length(x);
    %Calculando potencia
    Px = (abs(x).^2)/(Nx*fs_b);
    fx = (0:N_b-1)'*fs_b/Nx;
    subplot(2,2,3)
    x_x = fx(1:floor(Nx/2));                     %Magnitud
    x_y = 10*log(Px(1:floor(Nx/2)));             %Potencia
    plot(x_x,x_y)
    title('Caracterizaci�n de la se�al')
    xlabel('F (Hz)')
    ylabel('Potencia')
    hold on
    [peaks,loc] = findpeaks(x_y,'MinPeakDistance',1000);
    plot(fx(loc),peaks,'or')
    
% Caracterizaci�n Fibrilaci�n
    % Graficando la se�al filtrada
    subplot(2,2,2)
    plot(time_vector_f,output_final_f)
    legend('Se�al ECG2 - Fibrilaci�n - Filtrada')
    xlabel('Tiempo (s)')
    ylabel('Amplitud (mV)')
    title('Se�al 04015m - 60 segundos')

    %Utilizando FT y PSD para realizar una caracterizaci�n del comportamiento en
    %frecuencia de la se�al
    y = fft(output_final_f);
    Ny = length(y);
    %Calculando potencia
    Py = (abs(y).^2)/(Ny*fs_f);
    fy = (0:N_f-1)'*fs_f/Ny;
    subplot(2,2,4)
    y_x = fy(1:floor(Ny/2));                     %Magnitud
    y_y = 10*log(Py(1:floor(Ny/2)));             %Potencia
    plot(y_x,y_y)
    title('Caracterizaci�n de la se�al')
    xlabel('F (Hz)')
    ylabel('Potencia')
    hold on
    [peaks,loc] = findpeaks(y_y,'MinPeakDistance',1000);
    plot(fy(loc),peaks,'or')