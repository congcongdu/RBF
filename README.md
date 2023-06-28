# RBF
## Folder: Lorenz
- RK_Lorenz_5.m

  The time series of the system is calculated with RK4 and the corresponding derivative sequence is calculated using the five-point differential formula
  
- net_RK4_Lorenz.m 
  
  Think of the trained network as a new function network, calculate its time series with RK4, and calculate the corresponding derivative sequence using the five-point differential formula

- get_data_lorenz.m 
  
  Obtain time series and derivative sequences with random starting points under different parameters and store them (obtain datasets)
data_rbf_lorenz.m Train the network

- net_PSO.m
  
  Use the PSO algorithm to find the zero point of the function

- get_Jacobi.m 
  
  Calculate the approximate Jacobi matrix

- bifurcation.m 
  
  Obtains the bifurcation plot of equations and networks and determines the stability, and outputs the size of the RBF network


## Folder: Chen
- RK4_chen_5.m 
  
  The time series of the system is calculated with RK4 and the corresponding derivative series is calculated using the five-point differential formula

- get_data_chen.m 
  
  Obtain time series and derivative sequences with random starting points under different parameters and store them (obtain datasets)

- rbf_chen.m 
  
  Train the network        

- net_PSO 
  
  Use the PSO algorithm to find the zero point of the function

- get_Jacobi.m 
  
  Calculate the approximate Jacobi matrix

- bifurcation.m 
  
  Get the bifurcation plot of equations and networks and determine the stability

## Folder: ECG

- ZP.mat
  
  all the zero-points of the networks
  
- forFilterECG.m 
  
  Butterworth window filtering

- data_recombination.m 
  
  Train the network by preprocessing and merging the data

- ECG_PSO 
  
  Use the PSO algorithm to find the zero point of the function

- RK4_net.m 
  
  Think of the trained network as a new function network, and use RK4 to calculate its time series

- getPointSide.m 
  
  Check the position relationship of the point to the plane

- finfbestplane.m 
  
  Look for the best plane dividing the two clusters of points and plots
  
