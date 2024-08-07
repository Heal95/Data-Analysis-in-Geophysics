% Calculates fft of the function f defined at an interval centered around zero
% function g = fft_zp(f)
function g = fft_zp(f);
  n = length(f);
  if(mod(n,2)~=0)
    fprintf('n za sada mora biti paran');
    return
  else
    f = [f(n/2+1:n); f(1:n/2)];
    g = fft(f);
    g = [g(n/2+1:n); g(1:n/2)];
  end
  return
  
