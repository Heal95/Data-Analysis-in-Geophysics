Exercise - Empirical Orthogonal Function Analysis
-------------------------------------------------
For tasks 1 and 2 take three-hour series of temperature, air pressure, and E- and N-components of wind.

1. Examine the wind at your station. Plot a histogram for both components (two graphs on one image). Determine the principal axes of the wind, i.e., the direction in which the wind is strongest and weakest. Draw a scatter plot and overlay the principal axes in a different color. Calculate the root mean square speed of the wind components in the E and N directions, as well as in the direction of the principal axes. Determine the wind components in the principal axis system and plot them as time series on the same image with the original components. Verify that the wind energy does not depend on the coordinate system.
In the same manner as above, determine the directions of maximum and minimum variability of the wind, measured by standard deviations. In this case, at the beginning, subtract the mean values, i.e., instead of the second moment matrix around zero, work with the covariance matrix. The obtained directions represent the directions of the principal axes of the so-called standard deviation ellipse, whose center is located in the center of the (vector) time series, and the length of the axes is given by the standard deviations. Draw the standard deviation ellipse over the scatter plot.

2. Perform EOF analysis for temperature or pressure in one of the models, after subtracting the time means. On one image, draw three graphs: on the first, the EOF spectrum (eigenvalues of the covariance matrix normalized to 100%), on the second, several leading EOFs, and on the third, the principal component (PC) of the first mode. Using the "rule N", determine which eigenvalues are "significant" at the 95% level, indicating the threshold values for each eigenvalue on the first graph. Then "reasonably" reconstruct the original series for your station using as few modes as possible. Draw the original series and the reconstructed series over it, and the difference between the two series (two graphs on one image). On a separate image, draw all the original, centered series (i.e., anomalies) one above the other with an offset, and examine them together with the first image. Repeat the entire process for one wind component.
Instructions for the "rule N": Using the randn(m,n) function, where m is the number of stations and n is the length of the series, synthesize (e.g.) 1000 matrices of order m × n according to the normal distribution. For each of them, calculate the eigenvalues and store them, e.g., in a matrix of size m × 1000 and then determine the 0.95-th percentiles (e.g., using the prctile function). Also, draw histograms for several eigenvalues obtained from simulations.

3. Daily temperature fields from the LAMI forecast model (Italy) for the period from October 2, 2005, to October 1, 2006, are provided. Divide the field series into two parts, the first from 1 to 182 (cold part of the year) and the second from 183 to 365 (warm part of the year), select one fixed point (by clicking on the map) and calculate and plot the correlation maps for both parts of the year. A correlation map for a geophysical field (or for a time series of such fields) is a map (contours) of correlation coefficients between the field values at a given fixed point and at every other point of the same field. Then for both (series) fields, perform EOF calculations, make a reconstruction with a reasonable number of modes (e.g., 30-50 out of 365) and repeat the correlation calculations on the reconstructed fields.
---------------------------------------------------------------------------------------------------------------------
Files:
-----
LAMI_ECMWF_data.mat - exercise dataset for tasks 1 and 2
extract_data.m - Matlab code to extract data for fixed station; output: my_data.m
lami_temp.mat - exercise dataset for task 3
part_1.m - Matlab code for task 1
part_2.m - Matlab code for task 2
part_3.py - Python code for task 3
p3_modules.py - Modules for Python code for task 3
Report.pdf - Report with figures and results in croatian