%   this function computes cosine windos (refer to the definition)
function w = gen_cosine_window(sz)
w  = zeros(sz);
for i =1:sz(1)
    for j=1:sz(2)
        w(i,j) = sin((pi*i)/(sz(1)))*sin((pi*j)/(sz(2)));
    end;
end;

end