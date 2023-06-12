%% bifurcation diagram -- real system
% clc
% clear
a = 10;
c = 8/3;
b_list = 0:1:35;
fp = zeros(4,length(b_list));
kk = 1;
while kk <= length(b_list)
    b = b_list(kk);
    fp(1,kk) = b;
    fp(2,kk) = sqrt(c*(b-1));
    fp(3,kk) = fp(2,kk);
    fp(4,kk) = b-1;
    kk = kk+1;
end
fp = real(fp);
b = [-0.3:0.1:35.3];
x1 = real(sqrt(c*(b-1)));
x3 = b.*0;
hold on
plot(b,x1,b,-x1,b,x3,'Color',[190/255, 197/255, 181/255],'LineWidth',3)
%scatter(b,x1,'blue','filled')
%scatter(b,-x1,'b','filled')
%scatter(b,x3,'b','filled')
hold on
grid off
%xlabel('$\rho$',Interpreter='latex');
%ylabel('$\overline{x}$',Interpreter='latex')
xlim([0,35])
set(gca,'FontSize',18)
%% bifurcation diagram -- network

scatter(fp(1,:),fp(2,:),'MarkerFaceColor',[240/255,124/255,130/255],'MarkerEdgeColor','none')
hold on
%grid on
% scatter(fp0(1,:),fp0(2,:),'MarkerFaceColor',[240/255,124/255,130/255],'MarkerEdgeColor','none')
% scatter(fp_(1,:),fp_(2,:),'MarkerFaceColor',[240/255,124/255,130/255],'MarkerEdgeColor','none')
%xlabel('b');
%ylabel('$\overline{x}$',Interpreter='latex')
%set(gca,'FontSize',14)

%% judge stability -- real system
wd = zeros(2,length(b_list));
kk = 1;
% dd = 0.5;
while kk <= length(b_list)
    b = fp(1,kk);
    x = fp(2,kk);
    y = fp(3,kk);
    z = fp(4,kk);
% x = 0;
% y = 0;
% z = 0;
   JM = [-a a 0;b-z -1 -x; y x -c];
   e=eig(JM);
   fp(6:8,kk) = e;
    if e(1)<=0 && e(2)<=0 && e(3)<=0 
        wd(2,kk) = 1;%stable
    else
        wd(2,kk) = 0;%unstable
    end
    kk = kk+1;
end
fp(5,:) = wd(2,:);
% r0 = a*(a+c+3)/(b-c-1);

%% judge stability -- network
fp111 = fp;
wd = zeros(2,length(fp111));
kk = 1;
dd = 0.01;
e1=[];
% dd = 0.5;
while kk <= length(fp111)
    b = fp111(1,kk);
    x = fp111(2,kk);
    y = fp111(3,kk);
    z = fp111(4,kk);
    load(['lorenz,20*1000,0.001/b_',num2str(b),'.mat']);
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
    wd(1,kk) = b;
    
    JM = [(dx1(1)-dx0(1))/dd, (dx2(1)-dx0(1))/dd, (dx3(1)-dx0(1))/dd
          (dx1(2)-dx0(2))/dd, (dx2(2)-dx0(2))/dd, (dx3(2)-dx0(2))/dd
          (dx1(3)-dx0(3))/dd, (dx2(3)-dx0(3))/dd, (dx3(3)-dx0(3))/dd]; 
    e=eig(JM);
    e1=[e1 e];
    if e(1)<=0 && e(2)<=0 && e(3)<=0 
        wd(2,kk) = 1;%stable
    else
        wd(2,kk) = 0;%unstable
    end
    kk = kk+1;
end

%% seperate stable points from unstable points
n_wd=[]; % unstable
for j = 1:length(wd)
    if wd(2,j)==0
        aa = fp111(1:4,j);
        n_wd = [n_wd,aa];
    end
end
scatter(n_wd(1,:),n_wd(2,:),'MarkerFaceColor','b','MarkerEdgeColor','none')
% legend('理论值','稳定点','不稳定点')[121/255,145/255,209/255]

%% Output the size of the RBF network
b_list = 0:1:35;
for j = 1:1:length(b_list)
    b = b_list(j);
    netsize(1,j) = b;
    load(['lorenz,20*1000,0.001/b_',num2str(b),'.mat']);
    netsize(2,j) = length(net.IW{1});
end
bar(netsize(1,:),netsize(2,:))
grid off
set(gca,'FontSize',18)