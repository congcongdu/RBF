clc;
clear all;
close all; 
b_list = 5;
kk = 1;
while kk <= length(b_list)
    fprintf('%d of %d networks\n',kk,length(b_list));
    b = b_list(kk);
    if b == 0
        kk = kk+1;
        continue;
    end
%     zero = [sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;sqrt(beta*(rho-1)),-sqrt(beta*(rho-1)),0;rho-1,rho-1,0]
    N = 500; %Number of initial populations 
    d = 3; %Spatial dimension
    ger = 300; %Maximum number of iterations 
    limit = [0.5,15;0.5,15;0.5,5];
    % vlimit = [-1, 1]; %Set the speed limit 
    w = 0.8; %inertia weight 
    c1 = 0.5; %Self-learning factor 
    c2 = 0.5; %Cohort learning factor 
    for i = 1:d
        x(i,:) = limit(i, 1) + (limit(i, 2) - limit(i, 1)) * rand(1, N);
        %Location of the initial population
    end
    v = rand(d, N); %The velocity of the initial population 
    xm = x; %Historically best position for each individual
    ym = zeros(d, 1); %The best position in history
    fxm = 100*ones(1, N); %Historical optimal fitness for each individual 
    fym = inf; %Historical optimal fitness of the population  

    iter = 1; 
    record = zeros(ger, 1); %recorder 
    while iter <= ger 
        fx = f(x,b) ; %The individual's current fitness
        for i = 1:N 
            if fxm(i) > fx(i) 
                fxm(i) = fx(i); %Update individual historical optimal fitness
                xm(:,i) = x(:,i); %Update the individual's historical best position
            end
        end
        if fym > min(fxm) 
            [fym, nmin] = min(fxm); %Update the historical optimal fitness of the population 
            ym = xm(:,nmin); %Update the best position in the history of the group
        end
        v = v * w + c1 * rand * (xm - x) + c2 * rand * (repmat(ym, 1, N) - x);% 速度更新 
        x = x + v;% location update % work with boundary locations
        for jj = 1:N
            for ii = 1:d
                if x(ii,jj)>limit(ii,2)
                    x(ii,jj) = limit(ii,2);
                elseif x(ii,jj)<limit(ii,1)
                    x(ii,jj) = limit(ii,1);
                end
            end
        end
        record(iter) = fym;%record maximum % 
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
save(['zeropoint_simu/b_',num2str(b),'.mat'],'zp')
function re = f(x,b)
    load(['lorenz,20*1000,0.001/b_',num2str(b),'.mat'])
    input_zero=mapminmax('apply',x,inputps);
    an_beg = sim(net,input_zero);
    dd = mapminmax('reverse',an_beg,outputps);
    re = sum(dd.^2);
end