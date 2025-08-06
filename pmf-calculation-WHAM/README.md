This is a series of scripts to calculate the free energy and PMF from BEUS results.
Designed for calculations based on the WHAM algorithm (Weighted Histogram Analysis Method)
My system has colvars (hinge dihed quaternion quaternion quaternion quaternion quaternion),
but it can easily be adapted to any 1D colvar (hinge, dihed) and quaternions.
It takes in BEUS results, and outputs the free energy and PMF, as well as plots the result.

To run it:
1. run do.sh in 0-colvars to extract the colvar trajectories for each copy
2. run plot_hist.py to visualize the histogram to determine sampling overlap
3. run do.sh in 1-pot to calculate the biasing potentials
4. run do.sh or err.sh in 2-fe to use WHAM to estimate free energy (err.sh gives error estimates)
5. run do.sh to calculate the 1D / 2D PMF

This script is mostly python based. 
Compare the free energy with BRwGS, they should give the same result.
The npwham script in 2-fe comes from Mahmoud Moradi, find his scripts at: 
https://bslgroup.hosted.uark.edu/codes.shtml