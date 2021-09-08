% LECTURA DEL ARCHIVO DE AUDIO DE ENTRADA

infile = 'acoustic.wav';
[ x, Fs ] = audioread(infile);

% LÍMITES DE LA BANDA PASANTE
minf = 500;
maxf = 3000;

% FACTOR DE AMORTIGUAMIENTO
damp = 0.05;

% 'FRECUENCIA WAH'
Fw = 2000;

% VARIACIÓN EN HZ DE LA FRECUENCIA CENTRAL POR MUESTRA 
delta = Fw/Fs;

% VECTOR "SEÑAL TRIÁNGULO" QUE HARÁ MOVERSE A NUESTRA BANDA PASANTE ENTRE
% LOS LÍMITES ARRIBA DEFINIDOS
Fc = minf:delta:maxf;
while(length(Fc) < length(x) )
    Fc = [ Fc (maxf:-delta:minf) ];
    Fc = [ Fc (minf:delta:maxf) ];
end

% AJUSTE DEL VECTOR DE Fc A LA LONGITUD DE LA SEÑAL DE ENTRADA
Fc = Fc(1:length(x));

% FACTOR F1 DEL ALGORIMO DE FILTRADO
F1 = 2*sin((pi*Fc(1))/Fs);

% FACTOR Q1 DEL ALGORITMO DE FILTRADO
Q1 = 2*damp;

% CREACIÓN E INICIALIZACIÓN A CERO DE LOS VECTORES DE LAS VARIABLES DEL FILTRO
yh = zeros(size(x));
yb = zeros(size(x));
yl = zeros(size(x));

% ASIGNACIÓN DE VALORES PARA LA PRIMERA COMPONENTE (MUESTRA) ANTES DE
% ENTRAR AL BUCLE
yh(1) = x(1);
yb(1) = F1*yh(1);
yl(1) = F1*yb(1);

% ALGORITMO PRINCIPAL DE FILTRADO
for n = 2:length(x)
    yh(n) = x(n) - yl(n-1) - Q1*yb(n-1);
    yb(n) = F1*yh(n) + yb(n-1);
    yl(n) = F1*yb(n) + yl(n-1);
    F1 = 2*sin((pi*Fc(n))/Fs);
end

% ¿NORMALIZACIÓN? ¿PROMEDIADO?
maxyb = max(abs(yb));
yb = yb/maxyb;

% ESCRITURA DEL FICHERO DE SALIDA
audiowrite('out_wah.wav',yb, Fs);

% REPRESENTACIÓN DEL ESPECTRO EN MAGNITUD DE LA SEÑAL DE ENTRADA Y DE
% SALIDA
figure(1)
hold on
plot(x,'r');
plot(yb,'b');
title('Wah-wah and original Signal');