This is a revised version of SMwST (String Method with Swarms of Trajectories)
Modified based on the Moradi implementation, which can be found at https://bslgroup.hosted.uark.edu/codes.shtml.
The original version will fail if multiple samples per iteration (ns > 1) are used.
My revised version allows ns > 1, which reduces the processors required to have enough samples (equivalent to having more copies)

Usage:
1. Replace the smwst.namd script by Moradi with my script, and keep everything else the same