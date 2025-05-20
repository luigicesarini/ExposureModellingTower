# Exposure modelling of transmission towers for large-scale natural hazard risk assessments based on deep-learning object detection models

The repository contains materials related to the manuscript "Exposure modelling of transmission towers for large-scale natural hazard risk assessments based on deep-learning object detection models", under revision on the peer reviewed [Infrastructures](https://www.mdpi.com/journal/infrastructures).

<img src="https://github.com/luigicesarini/ExposureModellingTower/blob/main/img/fig1.jpg?raw=true" alt="" style="height: 50%; width:40%;border:solid 1px #555; float: left; margin-right: 15px;"/> 

The folder contains codes regarding the two object detection ML models used in the study to indentify towers and create exposure datasets, the training datasets, the codes regarding the querys to OpenStreetMap and Google Street View to retrieve street-level imagery, and the codes related to the strategies adopted to obtain the best possible images.

## Project Description

Exposure modelling plays a crucial role in disaster risk assessments by providing geospatial information about assets at risk and their characteristics. 
Detailed exposure data enhances the spatial representation of a rapidly changing environment, enabling decision-makers to develop effective policies for reducing disaster risk. This work proposes and demonstrates a methodology linking volunteered geographic information from OpenStreetMap (OSM), street-level imagery from Google Street View (GSV), and deep learning object detection models into the automated creation of exposure datasets for power grid transmission towers, assets particularly vulnerable to strong wind and other perils. Specifically, the methodology is implemented through a start-to-end pipeline that 
starts from the locations of transmission towers derived from OSM data to obtain GSV images capturing the towers in a given region, based on which their relevant features for risk assessment purposes are determined using two families of object detection models, i.e., single-stage and two-stage detectors. Both models adopted herein, You Only Look Once version 5 (YOLOv5) and Detectron2, achieved high values of mean average precision (mAP) for the identification and the classification tasks when applied to a pilot study area in northern Portugal comprising approximately 5.800 towers, highlighting the potential of
the approach for large-scale exposure modelling of transmission towers. By investigating the skill of the models in detecting towers of various sizes in the images, Detectron2 was found to outperform YOLOv5 in most metrics. The Detectron2 two-stage detector also exhibited higher confidence in its detection on a larger part of the study area.


## Features
The folder contains codes regarding the two object detection ML models used in the study to indentify towers and create exposure datasets, the training datasets, the codes regarding the querys to OpenStreetMap and Google Street View to retrieve street-level imagery, and the codes related to the strategies adopted to obtain the best possible images.


## Contributing
All the commit,pull, merge stuff that are unnecessary now.

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE License. See the [LICENSE](https://github.com/luigicesarini/ExposureModellingTower/blob/main/LICENSE.txt) file for more details. 

## Contact

For contact, you can reach out to this email: [luigi.cesarini@iusspavia.it](luigi.cesarini@iusspavia.it)