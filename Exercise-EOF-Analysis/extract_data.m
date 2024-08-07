close all; clear all;

load('LAMI_ECMWF_data.mat')

% station index, RI: i(1)

i = [3];
vL = v10mL(:,i);
vE = v10mE(:,i);
uL = u10mL(:,i);
uE = u10mE(:,i);

save my_data.mat vL vE uL uE