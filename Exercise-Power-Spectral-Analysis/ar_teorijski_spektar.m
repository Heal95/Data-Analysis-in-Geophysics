function sp = ar_teorijski_spektar(a,fr)
% Calculates theoretical spectrum AR(n) for the model whose coefficents are given in
% vector a (length n) in frequencies fr from [0 1/2]. Outputs vector
% sp same dimension as vector fr. 
% z.p. mar-2007.

% model order
    n = length(a);
% spectrum
    sp = 1./( abs(exp(fr*[0:n]*(-2*pi*i))*[1; a]).^2 );
    return
