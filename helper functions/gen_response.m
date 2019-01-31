function w = gen_response(pos, sz, var)
w  = zeros(sz);
for i =1:sz(1)
    for j=1:sz(2)
        vy  = i-pos(1);
        vx  = j-pos(2);        
        w(i,j) = exp(-0.5*(vx*vx+vy*vy)/var);
    end;
end;
end