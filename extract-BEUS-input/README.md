This is two scripts that can extract the results of SMwST as starting points of BEUS (Biased Exchanged Umbrella Sampling)
The copy-smwst.sh version copies the input from SMwST and the number of images and copies are exactly the same as in SMwST.
The more-windows.sh version can copy the input and add more images to get more sampling overlap.
For example, 30 images can be turned into 59, 88, 117, etc. The image is added by linear combination of closest images.

Usage:
1. Set the input files and desired images and copies