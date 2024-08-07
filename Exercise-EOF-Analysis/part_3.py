import numpy as np
import scipy.io as sio
import p3_modules as z3

# Collect and arrange data
matlab_data = sio.loadmat('./lami_temp.mat');
data = np.array(matlab_data['t2m_rezD']);
n = data.shape;

# Select data for point (x€[0,121], y€[0,118])
user_text = input('Enter x coordinate within interval [0,121]: ');
x = int(user_text);
user_text = input('Enter y coordinate within interval [0,118]: ');
y = int(user_text);
sta = np.tile(data[x, y, :], n[1]*n[0]).reshape(n);

# Run EOF module for cold and warm part of the year
user_text = input('Enter number of modes for EOF: ');
nm = int(user_text);

# Cold part of the year
in_data = data[:, :, 0:181]; in_sta = sta[:, :, 0:181]; 
data1, r1, EOF1, r1_EOF = z3.EOF(in_data=in_data, in_sta=in_sta, n=n, x=x, y=y, nm=nm);

# Warm part of the year
in_data = data[:, :, 182::]; in_sta = sta[:, :, 182::]; 
data2, r2, EOF2, r2_EOF = z3.EOF(in_data=in_data, in_sta=in_sta, n=n, x=x, y=y, nm=nm);

# Plotting results
user_text = input('Enter day of the cold part of the year [1,182]: ');
day1 = int(user_text) - 1;
user_text = input('Enter day of the warm part of the year [183,365]: ');
day2 = int(user_text) - 183;
z3.plot_model_EOF(day1=day1, day2=day2, data1=data1, EOF1=EOF1, data2=data2, EOF2=EOF2, x=x, y=y);
z3.plot_corr_maps(r1=r1, r1_EOF=r1_EOF, r2=r2, r2_EOF=r2_EOF, x=x, y=y);