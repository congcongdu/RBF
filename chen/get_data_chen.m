clc
clear
c_list = 14:1:40;
a = 35;
b = 3;
h = 0.001;
times = 500+2; %length of track
p = 20; % number of repetitions


for i = 1:length(c_list)
    c = c_list(i);
    r = [];
    de = [];
    while size(r,2)<times-3
        initial_con = rand(3,1)*c-c/2;
        [tmpr,tmpde] = RK4_chen_5(a,b,c,h,initial_con,times);
        r = [r,tmpr];
        de = [de,tmpde];
    end
    save(['real_data/real_c_',num2str(c),'_data.mat'],'r','de','b','c');
end