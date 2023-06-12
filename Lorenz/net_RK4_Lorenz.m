function [r,de] = net_RK4_Lorenz(b,h,initial_con,times)
    r(:,1) = initial_con;
    x(1) = r(1,1);
    y(1) = r(2,1);
    z(1) = r(3,1);
    for i=1:times+2
        [K1,L1,M1] = f(x(i),y(i),z(i),b);
        [K2,L2,M2] = f(x(i) + h*K1/2,y(i) + h*K1/2,z(i) + h*K1/2,b);
        [K3,L3,M3] = f(x(i) + h*K2/2,y(i) + h*K2/2,z(i) + h*K2/2,b);
        [K4,L4,M4] = f(x(i) + h*K3,y(i) + h*K3, z(i) + h*K3,b);

        x(i+1)=x(i)+h/6*(K1+2*K2+2*K3+K4);
        y(i+1)=y(i)+h/6*(L1+2*L2+2*L3+L4);
        z(i+1)=z(i)+h/6*(M1+2*M2+2*M3+M4);
        r(:,i+1) = [x(i+1);y(i+1);z(i+1)];
    end

    for j = 3:times
        de(:,j) = [(x(j-2)-8*x(j-1)+8*x(j+1)-x(j+2))/12/h;(y(j-2)-8*y(j-1)+8*y(j+1)-y(j+2))/12/h;(z(j-2)-8*z(j-1)+8*z(j+1)-z(j+2))/12/h];
    end
    
    r = r(:,3:times);
    de = de(:,3:times);
end

function [f1,f2,f3]= f(x,y,z,b)
load(['lorenz,20*1000,0.001/b_',num2str(b),'.mat']);
        input_zero=mapminmax('apply',[x;y;z],inputps);
        an_beg = sim(net,input_zero);
        dx = mapminmax('reverse',an_beg,outputps);
        f1 = dx(1);
        f2 = dx(2);
        f3 = dx(3);
end
