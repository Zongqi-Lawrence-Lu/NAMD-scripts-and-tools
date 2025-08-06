This is a series of scripts to calculate the free energy and PMF from BEUS results.
Designed for calculations based on the BRwGS algorithm (Bayesian Reweighting with Gibbs Sampler)
My system has colvars (hinge dihed quaternion quaternion quaternion quaternion quaternion),
but it can easily be adapted to any 1D colvar (hinge, dihed) and quaternions.
It takes in BEUS results, and outputs the free energy and PMF, as well as plots the result.

To run it:
1. run do.sh in 0-colvars to extract the colvar trajectories
2. run pot.sh in 1-pot to calculate the biasing potentials. (pot-uniform.sh is a previous version that only allows constant force constant across all windows)
3. run brwgs.sh or brwgs-aggregate.sh in 2-density to use BRwGS to estimate free energy (the aggregate version gives error estimates by standard deviation)
4. The PMF has not been implemented

This script is mostly shell+awk based. 
Compare the free energy with WHAM, they should give the same result.
The brwgs script in 2-density comes from Mahmoud Moradi, find his scripts at: 
https://bslgroup.hosted.uark.edu/codes.shtml
