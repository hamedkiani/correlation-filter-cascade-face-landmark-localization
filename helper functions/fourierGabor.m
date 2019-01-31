function [G g] = fourierGabor(sz, varargin)
% fourierGabor
%
% [G g] = fourierGabor(sz, nscale, norient, minWavelength, mult, s, dts)
% generates a set of even and odd log-Gabor filters. 
% Inputs:
%   sz = output size [M N] of the Fourier filters
%   nscale = the number of scales (optional = 3)
%   norient = the number of orientations (optional = 4)
%   minWavelength = minimal wavelength in pixels (optional = 3)
%   mult = scaling factor (optional = 2)
%   s = ratio of gaussian standard deviation to filter center frequency
%   (optional = 0.65)
%   dts = ratio of angular interval between filter orientations and
%   standard deviation of angular gaussian (optional = 1.5)
%
% Outputs:
%   G = filters in the Fourier domain
%   g = filters in the Spatial domain

  % override default arguments
  args = [5 8 3 2 0.65 1.5];%3,4,3,2,0.65,1.5
  for k = 1:nargin-1
    if ~isempty(varargin{k}), args(k) = varargin{k}; end
  end
  
  % set the arguments
  nsc     = args(1); 
  norient = args(2);
  minwave = args(3);
  mul     = args(4);
  sf      = args(5);
  dts     = args(6);
  M       = sz(1);
  N       = sz(2);
  
  % precompute the spatial extent
  [x, y]  = meshgrid(-1:2/N:1-2/N, -1:2/M:1-2/M);
  
  % normalised radius from the centre
  radius  = sqrt(x.^2 + y.^2);
  [zi,zj] = find(radius == 0);
  if zi, radius(zi,zj) = 1; end
  
  % sin-cosine modulation
  theta   = atan2(-y,x);
  sintheta= sin(theta);
  costheta= cos(theta);
  
  thetas  = pi/norient/dts;
  
  % generate all orientations
  angle(1,1,:) = (0:norient-1)*pi/norient;
  
  ds = bsxfun(@times, sintheta, cos(angle)) - bsxfun(@times, costheta, sin(angle));
  dc = bsxfun(@times, costheta, cos(angle)) + bsxfun(@times, sintheta, sin(angle));
  dtheta = abs(atan2(ds, dc));
  spread = exp((-dtheta.^2) / (2 * thetas^2));
  
  % generate all scales
  wave(1,1,1,:)  = minwave*mul.^(0:nsc-1);
  r = wave/2;
  log_r = log(bsxfun(@times, radius, r));
  log_s = log(sf);
  log_g = exp((-(log_r.^2))/(2*log_s^2));
  if zi, log_g(zi,zj,:,:) = 0; end
  
  % compose the angles and scales
  % Fourier filters
  G = bsxfun(@times, log_g, spread);
  G = fftshift(G,1);
  G = fftshift(G,2);
  
  % Spatial filters
  if nargout == 2
    g = ifft2(G);
    g = fftshift(g,1);
    g = fftshift(g,2);
  end
end
  
  
  