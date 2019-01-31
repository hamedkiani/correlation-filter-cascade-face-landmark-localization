%   This function returns the correlation response
function [rsps] = get_corr_resp(ind, imSz, fltSz, nbins, filtF, feat_cnlsF, varargin)

rsps = zeros(imSz(1), imSz(2), length(ind));

for indc=1:length(ind)
    rspF = sum(reshape(filtF(:,indc), imSz(1), imSz(2), []) .* feat_cnlsF,3);
    rsp = real(ifft2(rspF));
    rsp = circshift(rsp, -floor(fltSz/2));
    rsps(:,:,indc) = abs(rsp);
end;

end