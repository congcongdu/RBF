clear all
close all
clc

b_list = 0:1:35;

for i = 1:length(b_list)
    fprintf('%d of %d networks\n',i,length(b_list));
    b = b_list(i);
    load(['real_data/real_b_',num2str(b),'_data.mat'])
    [inputn,inputps]=mapminmax(r);
    [outputn,outputps]=mapminmax(de);

    %train the net
    net=newrb(inputn,outputn,1e-8,2);

    %save(['real_data_net_rbf/b_',num2str(b),'.mat'],'net','inputps','outputps');
end