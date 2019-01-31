%   this function performs power normalization, 0-mean, and 1-variance
function x = powerNormalise(x)
xmeanx = x-mean(x(:));
if std(xmeanx(:))>0
    x      = xmeanx / (std(xmeanx(:)));
end;
end