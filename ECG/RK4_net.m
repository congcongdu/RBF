function [r] = RK4_net(ind,h,initial_con,times)
%     a=10;
%     b=28;
%     c=8/3;
    r(:,1) = initial_con;
    x(1) = r(1,1);
    y(1) = r(2,1);
    z(1) = r(3,1);
    
    for i=1:times
        output = f_net(ind,[x(i);y(i);z(i)]);
        K1=output(1);
        L1=output(2);
        M1=output(3);
        
        output = f_net(ind,[x(i)+h/2*K1;y(i)+h/2*L1;z(i)+h/2*M1]);
        K2=output(1);
        L2=output(2);
        M2=output(3);

        output = f_net(ind,[x(i)+h/2*K2;y(i)+h/2*L2;z(i)+h/2*M2]);
        K3=output(1);
        L3=output(2);
        M3=output(3);
    
        output = f_net(ind,[x(i)+h/2*K3;y(i)+h/2*L3;z(i)+h/2*M3]);
        K4=output(1);
        L4=output(2);
        M4=output(3);
    
        x(i+1)=x(i)+h/6*(K1+2*K2+2*K3+K4);
        y(i+1)=y(i)+h/6*(L1+2*L2+2*L3+L4);
        z(i+1)=z(i)+h/6*(M1+2*M2+2*M3+M4);
        r(:,i+1) = [x(i+1);y(i+1);z(i+1)];
       
    end
end