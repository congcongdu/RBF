clc;
clear all;
close all; 
b_list = 1080;
kk = 1;
while kk <= length(b_list)
    fprintf('%d of %d networks\n',kk,length(b_list));
    b = b_list(kk);
    if b == 0
        kk = kk+1;
        continue;
    end
%     zero = [sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;rho-1,rho-1,0]
    N = 500;  
    d = 3; 
    ger = 300; 
%     lim = [-11,0];
%     lim = [-rho,-0.5];
%     lim = [0.5,rho];
%     ltmp = [lim(1)*ones(2,1),lim(2)*ones(2,1)]; 
    limit = [-1,1;-1,1;-1,3];
    % limit = [-100,100;-100,100];
    % vlimit = [-1, 1]; 
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
        fx = f(x,b) ;  
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
    if fym < 1e-6
        index = get_Jacobi(ym,b);
        zp(1,kk) = b;
        zp(2:4,kk) = ym;
%         zp(5:8,kk) = index;
        kk = kk+1;
    end
    disp(['minimum：',num2str(fym)]); 
    disp('the value of variables：');
    disp(ym)
end
save(['finished networks/SR_',num2str(b),'.mat'],'zp')
function re = f(x,b)
    load(['net_rbf_ecg/test',num2str(b),'.mat'])
    input_zero=mapminmax('apply',x,inputps);
    an_beg = sim(net,input_zero);
    dd = mapminmax('reverse',an_beg,outputps);
    re = sum(dd.^2);
end

function index = get_Jacobi(ym,b)
    load(['net_rbf_ecg/test',num2str(b),'.mat'])
    dd = 1e-2;
    tmp = [ym(1)+dd,ym(1),ym(1);
        ym(2),ym(2)+dd,ym(2);
        ym(3),ym(3),ym(3)+dd];
%     tmp = [ym(1)+dd,ym(1);
%         ym(2),ym(2)+dd];
    x = [ym,tmp];
    input_zero=mapminmax('apply',x,inputps);
    an_beg = sim(net,input_zero);
    b = mapminmax('reverse',an_beg,outputps);
    JM = [b(:,2)-b(:,1),b(:,3)-b(:,1),b(:,4)-b(:,1)]/dd;
    e = eig(JM);
    if sum(real(e)>0) == 3
        index = [e;1];
    else
        index = [e;0];
    end
end