function [y] = EfectoWahWah(damp,minf,maxf,Fs,Fw,x)

% LÍMITES DE LA BANDA PASANTE
fmin = minf;
fmax = maxf;

% FACTOR DE AMORTIGUAMIENTO
amort = damp;

% 'FRECUENCIA WAH'
Frecw = Fw;

% VARIACIÓN EN HZ DE LA FRECUENCIA CENTRAL POR MUESTRA 
delta = Frecw/Fs;

% VECTOR "SEÑAL TRIÁNGULO" QUE HARÁ MOVERSE A NUESTRA BANDA PASANTE ENTRE
% LOS LÍMITES ARRIBA DEFINIDOS
Fc = fmin:delta:fmax;
while(length(Fc) < length(x) )
    Fc = [ Fc (fmax:-delta:fmin) ];
    Fc = [ Fc (fmin:delta:fmax) ];
end

% AJUSTE DEL VECTOR DE Fc A LA LONGITUD DE LA SEÑAL DE ENTRADA
Fc = Fc(1:length(x));

% FACTOR F1 DEL ALGORIMO DE FILTRADO
F1 = 2*sin((pi*Fc(1))/Fs);

% FACTOR Q1 DEL ALGORITMO DE FILTRADO
Q1 = 2*amort;

% CREACIÓN E INICIALIZACIÓN A CERO DE LOS VECTORES DE LAS VARIABLES DEL FILTRO
yh = zeros(size(x));
y = zeros(size(x));
yl = zeros(size(x));

% ASIGNACIÓN DE VALORES PARA LA PRIMERA COMPONENTE (MUESTRA) ANTES DE
% ENTRAR AL BUCLE
yh(1) = x(1);
y(1) = F1*yh(1);
yl(1) = F1*y(1);

% ALGORITMO PRINCIPAL DE FILTRADO
for n = 2:length(x)
    yh(n) = x(n) - yl(n-1) - Q1*y(n-1);
    y(n) = F1*yh(n) + y(n-1);
    yl(n) = F1*y(n) + yl(n-1);
    F1 = 2*sin((pi*Fc(n))/Fs);
end

% ¿NORMALIZACIÓN? ¿PROMEDIADO?
maxyb = max(abs(y));
y = y/maxyb;

% ESCRITURA DEL FICHERO DE SALIDA
audiowrite('efecto.wav',y, Fs);

% REPRESENTACIÓN DEL ESPECTRO EN MAGNITUD DE LA SEÑAL DE ENTRADA Y DE
% SALIDA
figure(1)
hold on
plot(x,'r');
plot(y,'b');
title('Wah-wah and original Signal');

end