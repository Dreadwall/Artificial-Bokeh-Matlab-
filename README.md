# Artificial-Bokeh-Matlab-


This is the code for my artificial bokeh implementation.
This can be run by running defocus.m and specifying an image, and a given alpha. 
The ones I used in the results section are commented with specific alpha values in defocus.m.



Approach
--------
The approach of this code is to defocus based on a depth map generated from a machine learning algorithm.
The algorithm trained on the make3d using a forest cluster approach. 
This generated an approximate 3d depth map on a particular input image.

This is then used in combination with the median depth of the image (the proposed focus of the photo), and an alpha for correction.

The results replicate that of a tilt camera for artificial bokeh. 
However this code is farily extensible to allow the bokeh to only focus on a particular range of depths.
To make this change, the windows available would be built using a normal distribution. 



Special thanks to depth estimator creator - http://www.cs.cornell.edu/~asaxena/learningdepth/
And implementation code - https://github.com/king9014/rf-depth
