Exercise - Linear Regression
----------------------------
Take time series of three-hour and daily average temperatures, air pressure, and E- and N-components of wind for 30 locations (stations) along the Adriatic coast, for the period from November 2, 2002, to September 30, 2003. The series originate from the LAMI meteorological numerical model (Italy) and the European Centre for Medium-Range Weather Forecasts (ECMWF) model. Parts of the names of various variables have the following meanings: t2m, mslp, u10m, and v10m are temperature at 2 meters above ground (°C), air pressure reduced to mean sea level (hPa), and east and north wind components at 10 meters height (m/s), respectively. Dn means daily series, L means LAMI, and E means ECMWF. In this task, you will work with daily series.

Fix the i-th station (your station from now on), and among the remaining ones, select 5 stations. Between temperature and pressure, choose one element, and similarly, choose one wind component. Subtract the mean value from each series (e.g., the detrend command). Then perform linear regression of your station using the selected five stations in three ways, i.e., using Matlab’s function \, via normal equations, and via singular decomposition. Perform the calculations for each of the two chosen elements separately, for both LAMI and ECMWF, and verify that all methods yield the same results. For each element, plot the input time series and the series obtained by regression over it. On the second image, plot histograms of regression errors, and on the third, plot the squares of singular values normalized to 100%.

Select one model and for both elements from the first part, and for the same stations, perform linear regression via SVD, sequentially including one, two, ..., five SVD components. Plot the regression coefficients for all 5 cases (points connected by lines, each case in its own color, each element on its own plot). Examine the singular values and justify how many SVD components you would retain for each of the two elements.
---------------------------------------------------------------------------------------------------------------------
Files:
-----
LAMI_ECMWF_data.mat - exercise dataset
lin_reg.m - Matlab code to perform three linear regression methods (Matlab \, normal equations and SVD) and plot results
extract_data.m - Matlab code to extract data for fixed station; output: my_data.m
Report.pdf - Report with figures and results in croatian