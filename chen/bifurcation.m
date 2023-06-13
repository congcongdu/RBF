%% bifurcation diagram -- real system
% clc
% clear
a = 35;
b = 3;
c_list = 14:1:35;
% fp = zeros(4,length(c_list));
% kk = 1;
% while kk <= length(c_list)
%     c = c_list(kk);
%     fp(1,kk) = c;
%     fp(2,kk) = sqrt(b*(2*c-a));
%     fp(3,kk) = fp(2,kk);
%     fp(4,kk) = 2*c-a;
%     kk = kk+1;
% end
% fp = real(fp);
c = [14:0.01:35];
x1 = real(sqrt(b*(2*c-a)));
x3 = c.*0;
plot(c,x1,'Color',[190/255, 197/255, 181/255],'LineWidth',3)
hold on
grid on
plot(c,-x1,'Color',[190/255, 197/255, 181/255],'LineWidth',3)
plot(c,x3,'Color',[190/255, 197/255, 181/255],'LineWidth',3)
xlabel('c');

set(gca,'FontSize',14)

%% bifurcation diagram -- network
% load file
scatter(fp(1,:),fp(2,:),'MarkerFaceColor',[240/255,124/255,130/255],'MarkerEdgeColor','none')
hold on
grid on
xlabel('c');

set(gca,'FontSize',14)

%% judge stability -- real network
wd = zeros(2,length(c_list));
kk = 1;
% dd = 0.5;
while kk <= length(c_list)
    c = fp(1,kk);
    x = fp(2,kk);
    y = fp(3,kk);
    z = fp(4,kk);
% x = 0;
% y = 0;
% z = 0;
   JM = [-a a 0;c-a-z c -x; y x -b];
   e=eig(JM);
    if e(1)<=0 && e(2)<=0 && e(3)<=0 
        wd(2,kk) = 1;%稳定
    else
        wd(2,kk) = 0;
    end
    kk = kk+1;
end
% r0 = a*(a+c+3)/(b-c-1);

%% judge stability -- networks
wd = zeros(2,length(fp));
kk = 1;
dd = 0.01;
% dd = 0.5;
while kk <= length(fp)
    c = fp(1,kk);
    x = fp(2,kk);
    y = fp(3,kk);
    z = fp(4,kk);
    load(['chen,50*200,0.001/c_',num2str(c),'.mat']);
    input_zero=mapminmax('apply',[x;y;z],inputps);
    an_beg = sim(net,input_zero);
    dx0 = mapminmax('reverse',an_beg,outputps);
    input_zero=mapminmax('apply',[x+dd;y;z],inputps);
    an_beg = sim(net,input_zero);
    dx1 = mapminmax('reverse',an_beg,outputps);
    input_zero=mapminmax('apply',[x;y+dd;z],inputps);
    an_beg = sim(net,input_zero);
    dx2 = mapminmax('reverse',an_beg,outputps);
    input_zero=mapminmax('apply',[x;y;z+dd],inputps);
    an_beg = sim(net,input_zero);
    dx3 = mapminmax('reverse',an_beg,outputps);
    wd(1,kk) = c;
    
    JM = [(dx1(1)-dx0(1))/dd, (dx2(1)-dx0(1))/dd, (dx3(1)-dx0(1))/dd
          (dx1(2)-dx0(2))/dd, (dx2(2)-dx0(2))/dd, (dx3(2)-dx0(2))/dd
          (dx1(3)-dx0(3))/dd, (dx2(3)-dx0(3))/dd, (dx3(3)-dx0(3))/dd]; 
    e=eig(JM);
    if e(1)<=0 && e(2)<=0 && e(3)<=0 
        wd(2,kk) = 1;%stable
    else
        wd(2,kk) = 0;% unstable
    end
    kk = kk+1;
end

%% seperate
n_wd=[];
for j = 1:length(wd)
    if wd(2,j)==0
        aa = fp(1:4,j);
        n_wd = [n_wd,aa];
    end
end
scatter(n_wd(1,:),n_wd(2,:),'MarkerFaceColor',[121/255,145/255,209/255],'MarkerEdgeColor','none')