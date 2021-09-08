clear
close all

infile = 'acoustic.wav';
[x,Fs] = audioread('acoustic.wav');

damp = 0.05;
minf = 500;
maxf = 3000;
Fw = 2000;

y = EfectoWahWah(damp,minf,maxf,Fs,Fw,x);

sound(y,Fs);