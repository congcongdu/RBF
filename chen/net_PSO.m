clc;
clear all;
close all; %% 初始化种群 
c_list = 14:1:40;
kk = 1;
while kk <= length(c_list)
    fprintf('%d of %d networks\n',kk,length(c_list));
    c = c_list(kk);
    if c == 0
        kk = kk+1;
        continue;
    end
%     zero = [sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;rho-1,rho-1,0]
    N = 500;  
    d = 3; 
    ger = 300;  

    limit = [-1,1;-1,1;-1,1];
    % vlimit = [-1， 1]; 
    w = 0.8;  
    c1 = 0.5; 
    c2 = 0.5; 
    for i = 1:d
        x(i,:) = limit(i, 1) + (limit(i, 2) - limit(i, 1)) * rand(1, N);
    end
    v = rand(d, N); 
    xm = x; 
    ym = zeros(d, 1);  
    fxm = 100*ones(1, N); 
    fym = inf; 

    iter = 1; 
    record = zeros(ger, 1); 
    while iter <= ger 
        fx = f(x,c) ; 
        for i = 1:N 
            if fxm(i) > fx(i) 
                fxm(i) = fx(i); 
                xm(:,i) = x(:,i); 
            end
        end
        if fym > min(fxm) 
            [fym, nmin] = min(fxm);  
            ym = xm(:,nmin); 
        end
        v = v * w + c1 * rand * (xm - x) + c2 * rand * (repmat(ym, 1, N) - x);% 速度更新 
        x = x + v;
        for jj = 1:N
            for ii = 1:d
                if x(ii,jj)>limit(ii,2)
                    x(ii,jj) = limit(ii,2);
                elseif x(ii,jj)<limit(ii,1)
                    x(ii,jj) = limit(ii,1);
                end
            end
        end
        record(iter) = fym;
        iter = iter+1; 
    end
    if fym < 1e-2
        index = get_Jacobi(ym,c);
        zp(1,kk) = c;
        zp(2:4,kk) = ym;
%         zp(5:8,kk) = index;
        kk = kk+1;
    end
    disp(['minimun：',num2str(fym)]); 
    disp('the value of variables：');
    disp(ym)
end
save(['zeropoint_simu/c_',num2str(c),'.mat'],'zp')
function re = f(x,b)
    load(['chen,20*500,0.001/c_',num2str(b),'.mat'])
    input_zero=mapminmax('apply',x,inputps);
    an_beg = sim(net,input_zero);
    dd = mapminmax('reverse',an_beg,outputps);
    re = sum(dd.^2);
end