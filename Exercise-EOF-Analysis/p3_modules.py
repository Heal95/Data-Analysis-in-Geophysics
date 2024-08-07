#!/usr/bin/env python

#module p3_modules
#coding=utf-8

# Importing modules
import numpy as np
import matplotlib.pyplot as plt

def EOF(in_data, in_sta, n, x, y, nm):
	# Remove mean values
	data = in_data; sta = in_sta; 
	n1 = in_data.shape; in_data_m = np.mean(in_data, axis=2); in_sta_m = np.mean(in_sta, axis=2);

	for i in range(0, n1[2]):
		sta[:, :, i] = in_sta[:, :, i] - in_sta_m;
		data[:, :, i] = in_data[:, :, i] - in_data_m;

	# Calculate standard Pearson correlation coefficient
	r = np.sqrt(np.sum(sta*data, axis=2) / np.sqrt(np.sum(sta**2, axis=2) * np.sum(data**2, axis=2)));

	# EOF - SVD
	data_flat = np.zeros([n[0]*n[1], n1[2]]);
	for i in range(0, n1[2]):
		data_flat[:, i] = data[:, :, i].flatten();

	U, S, V = np.linalg.svd(data_flat, full_matrices=False);
	Coef = np.matmul(np.diag(S), V);

	EOF_flat = np.matmul(U[:, 0:nm], Coef[0:nm, :]); # First nm modes
	EOF = np.zeros(n1);
	for i in range(0, n1[2]):
		EOF[:, :, i] = np.reshape(EOF_flat[:, i], (n[0], n[1]), order='C');

	sta_EOF = np.tile(EOF[x, y, :], n[1]*n[0]).reshape(n1);

	# Calculate standard Pearson correlation coefficient
	r_EOF = np.sqrt(np.sum(sta_EOF*EOF, axis=2) / np.sqrt(np.sum(sta_EOF**2, axis=2) * np.sum(EOF**2, axis=2)));

	return(data, r, EOF, r_EOF)

def plot_model_EOF(day1, day2, data1, EOF1, data2, EOF2, x, y):
	vmin1 = min([min(data1[:, :, day1].min(axis=1)), min(EOF1[:, :, day1].min(axis=1))]);
	vmin2 = min([min(data2[:, :, day2].min(axis=1)), min(EOF2[:, :, day2].min(axis=1))]);
	vmax1 = max([max(data1[:, :, day1].max(axis=1)), max(EOF1[:, :, day1].max(axis=1))]);
	vmax2 = max([max(data2[:, :, day2].max(axis=1)), max(EOF2[:, :, day2].max(axis=1))]);

	fig, axes = plt.subplots(2, 2);
	cntr1 = axes[0, 0].contourf(data1[:, :, day1]);
	cntr1.set_clim(vmin=vmin1, vmax=vmax1);
	axes[0, 0].plot(y, x,'+k');
	axes[0, 0].title.set_text('Model - hladni dio god.');
	cbar = plt.colorbar(cntr1, ax=axes[0, 0]);

	cntr2 = axes[1, 0].contourf(data2[:, :, day2]);
	cntr2.set_clim(vmin=vmin2, vmax=vmax2);
	axes[1, 0].plot(y, x,'+k');
	axes[1, 0].title.set_text('Model - topli dio god.');
	cbar = plt.colorbar(cntr2, ax=axes[1, 0]);

	cntr3 = axes[0, 1].contourf(EOF1[:, :, day1]);
	cntr3.set_clim(vmin=vmin1, vmax=vmax1);
	axes[0, 1].plot(y, x,'+k');
	axes[0, 1].title.set_text('EOF - hladni dio god.');
	cbar = plt.colorbar(cntr1, ax=axes[0, 1]);

	cntr4 = axes[1, 1].contourf(EOF2[:, :, day2]);
	cntr4.set_clim(vmin=vmin2, vmax=vmax2);
	axes[1, 1].plot(y, x,'+k');
	axes[1, 1].title.set_text('EOF - topli dio god.');
	cbar = plt.colorbar(cntr2, ax=axes[1, 1]);
	plt.show();

def plot_corr_maps(r1, r1_EOF, r2, r2_EOF, x, y):
	vmin1 = min([min(r1.min(axis=1)), min(r1_EOF.min(axis=1))]);
	vmin2 = min([min(r2.min(axis=1)), min(r2_EOF.min(axis=1))]);
	vmax1 = max([max(r1.max(axis=1)), max(r1_EOF.max(axis=1))]);
	vmax2 = max([max(r2.max(axis=1)), max(r2_EOF.max(axis=1))]);

	fig, axes = plt.subplots(2, 2);
	cntr1 = axes[0, 0].contourf(r1, cmap='plasma');
	cntr1.set_clim(vmin=vmin1, vmax=vmax1);
	axes[0, 0].plot(y, x,'+k');
	axes[0, 0].title.set_text('Model - hladni dio god.');
	cbar = plt.colorbar(cntr1, ax=axes[0, 0]);

	cntr2 = axes[1, 0].contourf(r2, cmap='plasma');
	cntr2.set_clim(vmin=vmin2, vmax=vmax2);
	axes[1, 0].plot(y, x,'+k');
	axes[1, 0].title.set_text('Model - topli dio god.');
	cbar = plt.colorbar(cntr2, ax=axes[1, 0]);

	cntr3 = axes[0, 1].contourf(r1_EOF, cmap='plasma');
	cntr3.set_clim(vmin=vmin1, vmax=vmax1);
	axes[0, 1].plot(y, x,'+k');
	axes[0, 1].title.set_text('EOF - hladni dio god.');
	cbar = plt.colorbar(cntr1, ax=axes[0, 1]);

	cntr4 = axes[1, 1].contourf(r2_EOF, cmap='plasma');
	cntr4.set_clim(vmin=vmin2, vmax=vmax2);
	axes[1, 1].plot(y, x,'+k');
	axes[1, 1].title.set_text('EOF - topli dio god.');
	cbar = plt.colorbar(cntr2, ax=axes[1, 1]);
	plt.show()