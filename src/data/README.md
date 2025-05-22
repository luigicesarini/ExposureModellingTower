# Structure of the data/ folder

In this folder are located the script for, getting the tower from OSM, finding the closest GSV points, and the optimal parameters.

Specifically:
- __get_tower.py:__ Contains the query to OSM to retrieve the tower for a specifci bounding box.
- __get_closest_road.R:__ Finds the n closest (i.e., n=4) points to the each tower.
- __get_GSV_metadata.py:__ Find the metadata of the GSV image for the points retrieved above.
- __img_param.r:__ Computes the parameters required for requesting the GSV image.



