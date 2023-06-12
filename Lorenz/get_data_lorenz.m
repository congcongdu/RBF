clc
clear
b_list = 0:1:35;
a = 10;
c = 8/3;
h = 0.001;
times = 100+2; %track length
p = 101; %number of repetitons

for i = 1:length(b_list)
    b = b_list(i);
    r = [];
    de = [];
    while size(r,2)<times-3
        initial_con = rand(3,1)*b-b/2;
        [tmpr,tmpde] = RK4_Lorenz_5(a,b,c,h,initial_con,times);
        % [tmpr,tmpde] = ran_in(a,b,c,h,initial_con,times);
        r = [r,tmpr];
        de = [de,tmpde];
    end
    save(['real_data/real_b_',num2str(b),'_data.mat'],'r','de','b','c');
end