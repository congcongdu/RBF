function index = get_Jacobi(ym,c)
    load(['chen,20*500,0.001/c_',num2str(c),'.mat'])
    dd = 1e-2;
    tmp = [ym(1)+dd,ym(1),ym(1);
        ym(2),ym(2)+dd,ym(2);
        ym(3),ym(3),ym(3)+dd];
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