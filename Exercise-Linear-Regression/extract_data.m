close all; clear all;

load('LAMI_ECMWF_data.mat')

% station index, RI: i(1)

i = [3 4 5 6 7 8];

t_LAMI = detrend(t2mDnL(:,i), 'constant');
t_ECMWF = t2mDnE(:,i) - mean(t2mDnE(:,i),'omitnan');
t_ECMWF(isnan(t_ECMWF)) = 0;
v_LAMI = detrend(v10mDnL(:,i), 'constant');
v_ECMWF = v10mDnE(:,i) - mean(v10mDnE(:,i),'omitnan');
v_ECMWF(isnan(v_ECMWF)) = 0;

save my_data.mat t_LAMI t_ECMWF v_LAMI v_ECMWF