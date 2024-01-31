%% CLEAR MEMORY 
%close all;
clear    ;
clc      ;
Pri = zeros(256,4);
%% Loading path 
for nn=1:4
    a = sprintf('path\\P%d.mat',nn);
    b = load(a);
    c = sprintf('b.P%d',nn);
    d = eval(c)   ;
    Pri(:,nn) = d ;
end
%
Sec = zeros(256,4,4);
for ss = 1:4
    for mm = 1:4
        a = sprintf('path\\S%d%d.mat',ss,mm);
        b = load(a);
        c = sprintf('b.S%d%d',ss,mm);
        d = eval(c)   ;
        Sec(:,mm,ss)=d;
    end
end
%% Generate noise 
fs =  16000;
t  =  40;
T  = 0:1/fs:t ;
len= length(T);
Re = randn(len,1);
%Re = 0.65*sin(2*pi*500*T)' + 0.25*sin(2*pi*300*T)' + 0.15*sin(2*pi*250*T)';
% bf = fir1(512,[0.05 0.1]);
% Re = filter(bf,1,Re);
%% Filtering the reference signal ...
bf = fir1(512,[0.05 0.1]);
Re = filter(bf,1,Re);
%%
Re1 = [Re';Re';Re';Re'];
Dir = zeros(4,len);
for jj = 1:4
    Dir(jj,:) = (filter(Pri(:,jj),1,Re1(jj,:)))';
end
zo = zeros(len,1);
% ReA1 = [Re';zo';zo';zo'];
% ReA2 =  
Red = Re1 ;
%Red = randn(4,len);
%% System configuration 
Wc  = zeros(512,1,4); % Implement a 4-by-4-by-4 full channel FxLMS.
muW = 0.00001;
%% Multichannel FxLMS algorithm 
%---Wc [Filter length x Control unit/ microphone x Reference microphone number]
%---Sec[Filter length x Error number x Speaker number]
a = Multichannel_FxLMS(Wc,Sec,muW);
%---Red is referernce  [Reference microphone number x signal length]
%---Dir is Disturabnce [Error microphone number x signal length]
[E,a]= a.FxLMS_cannceller(Red,Dir);
%% Drawing the figure 
%%
figure 
subplot(2,2,1)
plot(E(1,:));
grid on ;
subplot(2,2,2)
plot(E(2,:));
grid on ;
subplot(2,2,3)
plot(E(3,:));
grid on ;
subplot(2,2,4)
plot(E(4,:));
grid on ;
W1=a.Get_coefficients();
figure 
subplot(2,2,1)
plot(W1(:,1));
grid on ;
subplot(2,2,2)
plot(W1(:,2));
grid on ;
subplot(2,2,3)
plot(W1(:,3));
grid on ;
subplot(2,2,4)
plot(W1(:,4));
grid on ;
%%
save('collocated_weigth.mat','W1','E');