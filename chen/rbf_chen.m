clear all
close all
clc

c_list = 14:1:40;%finished 

for i = 1:length(c_list)
    fprintf('%d of %d networks\n',i,length(c_list));
    c = c_list(i);
    load(['real_data/real_c_',num2str(c),'_data.mat'])
    [inputn,inputps]=mapminmax(r);
    [outputn,outputps]=mapminmax(de);

    %train network
    net=newrb(inputn,outputn,1e-8,2);

    save(['chen,real,20*500,0.001/c_',num2str(c),'.mat'],'net','inputps','outputps');
end