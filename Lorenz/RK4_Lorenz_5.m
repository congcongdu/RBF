function [r,de] = RK4_Lorenz_5(a,b,c,h,initial_con,times)
% a,b,c are the parameters of the system; h is the interation step.
    r(:,1) = initial_con;
    x(1) = r(1,1);
    y(1) = r(2,1);
    z(1) = r(3,1);
% RK-4    
    for i=1:times+2
        K1=a*(y(i)-x(i));
        L1=b*x(i)-y(i)-x(i)*z(i);
        M1=x(i)*y(i)-c*z(i);
    
        K2=a*((y(i)+h/2*L1)-(x(i)+h/2*K1));
        L2=b*(x(i)+h/2*K1)-(x(i)+h/2*K1)*(z(i)+h/2*M1)-(y(i)+h/2*L1);
        M2=(x(i)+h/2*K1)*(y(i)+h/2*L1)-c*(z(i)+h/2*M1);
    
        K3=a*((y(i)+h/2*L2)-(x(i)+h/2*K2));
        L3=b*(x(i)+h/2*K2)-(x(i)+h/2*K2)*(z(i)+h/2*M2)-(y(i)+h/2*L2);
        M3=(x(i)+h/2*K2)*(y(i)+h/2*L2)-c*(z(i)+h/2*M2);
    
        K4=a*((y(i)+h*L3)-(x(i)+h*K3));
        L4=b*(x(i)+h*K3)-(x(i)+h*K3)*(z(i)+h*M3)-(y(i)+h*L3);
        M4=(x(i)+h*K3)*(y(i)+h*L3)-c*(z(i)+h*M3);
    
        x(i+1)=x(i)+h/6*(K1+2*K2+2*K3+K4);
        y(i+1)=y(i)+h/6*(L1+2*L2+2*L3+L4);
        z(i+1)=z(i)+h/6*(M1+2*M2+2*M3+M4);
        r(:,i+1) = [x(i+1);y(i+1);z(i+1)];
       
    end
% five point differential formula with an accuracy of h^4
    for j = 3:times
        de(:,j) = [(x(j-2)-8*x(j-1)+8*x(j+1)-x(j+2))/12/h;(y(j-2)-8*y(j-1)+8*y(j+1)-y(j+2))/12/h;(z(j-2)-8*z(j-1)+8*z(j+1)-z(j+2))/12/h];
    end
    
    r = r(:,3:times);
    de = de(:,3:times);
end