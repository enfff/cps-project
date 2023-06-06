function x_new = IST_v2(x_old, L)
    x_new = x_old;
    x_new(x_old>L) = x_old(x_old>L) - L(x_old>L); 
    x_new(x_old<-L) = x_old(x_old<-L) + L(x_old<-L);
    x_new(abs(x_old)<L) = 0;
end