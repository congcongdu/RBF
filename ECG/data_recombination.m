clc
clear
% data number
ind_list = [1,2,3,4,5];

kk = 1;
n = 3;  %Dimensionality reduction
Hz1 = 500; % data sampling rate
Hz = 3000; % target sample rate
h = 1/Hz;  % step size
l = 5000;   % The length required for each set of data
p = 500;    % sliding average order
r = [];
de = [];

while kk <= length(ind_list)
    fprintf('第%d组数据，共%d组\n',kk,length(ind_list));
    ind = ind_list(kk);
%     load(['dataset/JS000',num2str(ind),'.mat'])
    csvread(['dataset/SVT/SVT_',num2str(ind),'.csv']);
    times = length(ans);
    val = ans./5000;
    % resample
    val=resample(val,Hz,Hz1);
    % filering
    val = forFilterECG(val,Hz);
    val = val';
    % VCG
    x = 0.38*val(1,:)-0.07*val(2,:)-0.13*val(7,:) ...
    +0.05*val(8,:)-0.01*val(9,:)+0.14*val(10,:)+0.06*val(11,:)+0.54*val(12,:);
    y = -0.07*val(1,:)+0.93*val(2,:)+0.06*val(7,:) ...
    -0.02*val(8,:)-0.05*val(9,:)+0.06*val(10,:)-0.17*val(11,:)+0.13*val(12,:);
    z = 0.11*val(1,:)-0.23*val(2,:)-0.43*val(7,:) ...
    -0.06*val(8,:)-0.14*val(9,:)-0.20*val(10,:)-0.11*val(11,:)+0.31*val(12,:);
    val = [x;y;z];

    % smooth data
    val = smoothdata(val,'loess',p);
    % Five-point differential formula
    r0 = real(val);
    x = r0(1,:);
    y = r0(2,:);
    z = r0(3,:);
    for j = 3:length(x)-2
            de0(:,j) = [(x(j-2)-8*x(j-1)+8*x(j+1)-x(j+2))/12/h;(y(j-2)-8*y(j-1)+8*y(j+1)-y(j+2))/12/h;(z(j-2)-8*z(j-1)+8*z(j+1)-z(j+2))/12/h];
    end
    r_full1 = [x(:,3:end-2);y(:,3:end-2);z(:,3:end-2)];
    de_full1 = de0(:,3:end);
    r_full = r_full1(:,1:l);
    de_full = de_full1(:,1:l);
    r = [r,r_full];
    de = [de,de_full];

    kk = kk+1;
end
%% train network
tic
fprintf('start training');
[inputn,inputps]=mapminmax(r);
[outputn,outputps]=mapminmax(de);


% net=newrb(inputn,outputn,1e-8,200);
net=newrbe(inputn,outputn,1);


save(['net_rbf_ecg/test'],'net','inputps','outputps');
toc

%% test
load(['net_rbf_ecg/test'])
n=3;
x = r_full1(:,1:5000);
input_zero=mapminmax('apply',x,inputps);
an_beg = sim(net,input_zero);
b = mapminmax('reverse',an_beg,outputps);
figure(1)
plot3(b(1,:),b(2,:),b(3,:))
hold on
plot3(de_full1(1,1:5000),de_full1(2,1:5000),de_full1(3,1:5000))
axis off

figure(3)
A = b-de_full1(:,1:5000);
plot(A(1,:))
hold on
plot(A(2,:))
plot(A(3,:))
