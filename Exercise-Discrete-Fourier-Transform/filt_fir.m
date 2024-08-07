function y = filt_fir(x,f)
% Filters array x with filter whose coefficients are given in f
% z.p. 14-May-2017

n = length(f); m = length(x);
if(m<n)
  fprintf('ulazni niz je prekratak')
else
  y = conv(f,x); nn = length(y);
  if(mod(n,2)==1)
    y = y((n+1)/2:nn-(n-1)/2); % neparna duljina
    y(1:(n-1)/2) = NaN; y(m-(n-1)/2+1:m) = NaN;
  else
    y = y(n/2+1:nn-(n/2-1));  % parna duljina
    y(1:n/2-1) = NaN; y(m-n/2+1:m) = NaN;
  end
end
return
  
