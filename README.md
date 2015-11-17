# ArucoPrecisionCheck

Cheching the precision of Aruco fiducial marker library.
I am testing against aruco-1.3.0

Dependencies:
Aruco is compiled against Opencv 2.4.9

Experiment description.
Get a series of images with the markers and a close form figure. Annotate in
the first image the coordinates of the close form figure. Reproject theses
annotations to the other images and compare with the ground truth.
