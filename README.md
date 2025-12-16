# NAMD Simulation Scripts and Tools

This folder contains a curated collection of Python, Tcl, and Bash scripts I developed while working on molecular dynamics (MD) simulations using NAMD for protein systems. These tools are used in:

- Free energy calculation by generating inputs to two different methods (WHAM and BEUS)
- Automatically extracts/generates the input file to SMD, SMwST, and BEUS
- Output monitoring and analysis, with focus on angles and quaternions colvars

These scripts were developed as part of my research under the mentorship of Prof. Esmael Haddadian at UChicago, where we use high-performance computing (HPC) clusters to run enhanced sampling simulations. 

As of November 2025, my project studies are exploring the conformational transition between open and closed states of insulin-degrading enzyme in the presence of insulin and Amyloid-β using molecular dynamics simulation. Feel free to contact me if you are interested in my project or have questions about any of the scripts.


# Repository Structure

| Folder                   | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| pmf-calculation-WHAM     | Create the input files to calculate PMF with WHAM                           |
| pmf-calculation-BRwGS    | Create the input files to calculate PMF with BRwGS                          |
| monitor-SMD-progress     | Script to monitor the colvar status (angle, dihed, distance) in a reaction |
| extract-SMwST-input      | Extract the input at desired nanoseconds as inputs to SMwST                |
| monitor-SMwST-progress   | Calculates string RMSD and plots several graphs to monitor SmwST convergence|
| extract-BEUS-input       | Extract the desired number of images and copies (can add images) from SMwST to start BEUS |

# Highlighted Features

1. WHAM and BRwGS PMF Calculation:
  - Extracts colvars, determines biasing potentials, computes free energy with WHAM/BRwGS, and calculates and plots the PMF.
  - The Python script is faster and more readable than the original bash + awk script.
  - Using both methods can validate the results.
  - More visualizations than the original script with the colvar histogram overlap and the 2D PMF landscape.

2. Monitoring Tools:
  - Analyze colvar time series to monitor reaction process, SMwST convergence that VMD does not support on its own
  - Faster and more robust string RMSD calculation with Python
  - More options for extracting inputs: SMwST inputs can be extracted by providing a list of times; can customize the number of images as the starting point for BEUS

# Requirements

- Python ≥ 3.9, NAMD >= 2.14, VMD >= 1.9.4
- Python libraries: NumPy, Matplotlib
- Shell libraries: Gnuplot, Awk
- The smwst.namd, beus.namd, brwgs, npwham scripts can be found at the Moradi lab website: https://bslgroup.hosted.uark.edu/codes.shtml


# Background

These tools support simulations involving:
- Steered / Targeted Molecular Dynamics (SMD/TMD)
- String Method with Swarms of Trajectories (SMwST)
- Biased-Exchanged Umbrella Sampling (BEUS)
- High-dimensional free energy surface reconstruction

They are used in active research on protein conformational changes.
The configuration files and workflows can be found on the Moradi tutorial: Exploring Complex Conformational Transition Pathways.
