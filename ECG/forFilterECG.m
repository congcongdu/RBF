function [filterData] = forFilterECG(thedata,SampleRate)

fp = 20;
fs = 45;
ap = 1;
as = 40;
Fs1 = SampleRate;
wp = 2*pi*fp/Fs1;
ws = 2*pi*fs/Fs1;
Fs = Fs1/Fs1;
T = 1/Fs;
Op = 2/T*tan(wp/2);
Os = 2/T*tan(ws/2);
[N,Wn] = buttord(Op,Os,ap,as,'s');
[z,p,k] = buttap(N);
[b,a] = zp2tf(z,p,k);
[B,A] = lp2lp(b,a,Op);
[Bz,Az] = bilinear(B,A,Fs*T/2);
% [H,w] = freqz(Bz,Az,256,Fs*Fs1);
% plot(w,abs(H),'r');


Fs=Fs1;
wp=0.7*2/Fs;
ws=0.1*2/Fs;
Rp=1;
Rs=40;
Nn=128;
[N,Wn]=buttord(wp,ws,Rp,Rs);
[b,a]=butter(N,Wn,'high');
% [H,f]=freqz(b,a,Nn,Fs);

y1=filtfilt(Bz,Az,thedata);
filterData=filtfilt(b,a,y1);

filterData = medfilt1(filterData,3);
end

