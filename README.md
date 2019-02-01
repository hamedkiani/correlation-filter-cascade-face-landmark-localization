
# <p align="center"> Correlation Filter Cascade for Facial Landmark Localization

### <p align="center"> Hamed Kiani and Terence Sim

### <p align="center"> WACV 2016

## Abstract

The application of correlation filters for the task of facial
landmark detection has been studied by many vision works.
Their success, however, is limited by the presence of large
pose variations, expression and occlusion in face images.
Moreover, existing correlation filters may suffer from poor
discrimination to distinguish visually similar landmarks
such as the right and left eyes. In this work, we present a
new framework, referred to as Correlation Filter Cascade,
to address the above limitations. The proposed framework
consists of a set of correlation filters with different spatial
supports (sizes) which are connected together in a cascade
form. More specifically, the size of filters decreases from the
lower to upper levels. Filters at lower levels implicitly code
face shape information since they are trained using large
patches stemmed from face images. This avoids ambiguous
detection caused by landmarks with similar appearance.
Detection in these levels, however, may not be accurate
and suffer from small localization errors, mainly caused by
face pose, expression and occlusion. Therefore, locations
detected by lower levels will be further used by the higher
levels to narrow down their search regions. Since the filters
at higher levels have smaller size, they are less affected by
pose, expression and occlusion, and thus, can perform more
accurately. The evaluation on BioID and LFPW shows the
superiority of our method compared to prior correlation filters
and leading facial landmark detectors.

## Core idea: learning from background patches

we introduce a cascade
framework for the task of facial landmark localization in the following figure depicting the scheme of the proposed framework. In
particular, our framework consists of a set of correlation filters
with different spatial supports (sizes) which are hierarchically
connected together in a cascade manner. The size
of filters decreases from lower to higher levels, meaning that
filters at lower levels have bigger size compared to those at
higher levels. Filters at lower levels are trained using bigger
patches (for instance, the filter at level 0 in Fig. 1 is
trained using whole face images) and explicitly capture face
shape information. This offers stability against ambiguous
detection. Filters at higher levels, on the other hand, are
trained using smaller patches, and, as a result, are more robust
against uncontrolled face pose, occlusion and expression.
The correlation outputs returned by each level is used
to narrow down the search region for its upper level. The
final landmark location is determined by averaging the locations
estimated by all filters over the cascade framework.


 ![](https://github.com/hamedkiani/correlation-filter-cascade-face-landmark-localization/blob/master/imgs/intro.png?raw=true)

<br>

## Quantitative results

1) Accurate landmark detection over cascade levels. The ground truth and predicted locations are shown by blue dots and red
squares, respectively. The images are selected from the LFPW testing set.

![](https://github.com/hamedkiani/correlation-filter-cascade-face-landmark-localization/blob/master/imgs/img_1.png?raw=true)

<br><br>

2) Detection examples of the LPFW dataset. The first two rows show the successful detections under challenging circumstances of
expression, occlusion, pose, lighting and poor quality. The third row shows some failed cases. The red and blue marks respectively show the detected landmark and the ground truth.

![](https://github.com/hamedkiani/correlation-filter-cascade-face-landmark-localization/blob/master/imgs/img_2.png?raw=true)

<br><br>

3) Detection examples of the BioID dataset. The red squares and blue dots represent the detected and ground truth landmarks, respectively.

![](https://github.com/hamedkiani/correlation-filter-cascade-face-landmark-localization/blob/master/imgs/img_3.png?raw=true)


## Running instructions

The code for training and testing cascade level of correlation filters (multi channel correlation filters) are provided above. You can define different levels with different size, and different features for different landmarks.

The mat files for BioID are provided, run train_test_BioID.m in MATLAB and you see the evaluation results.


## Reference

http://www.hamedkiani.com/uploads/5/1/8/8/51882963/cascade_cf_camera_ready_submitted.pdf

```
@inproceedings{galoogahi2016correlation,
  title={Correlation filter cascade for facial landmark localization},
  author={Galoogahi, Hamed Kiani and Sim, Terence},
  booktitle={Applications of Computer Vision (WACV), 2016 IEEE Winter Conference on},
  pages={1--8},
  year={2016},
  organization={IEEE}
}
```

```
@inproceedings{kiani2013multi,
  title={Multi-channel correlation filters},
  author={Kiani Galoogahi, Hamed and Sim, Terence and Lucey, Simon},
  booktitle={Proceedings of the IEEE international conference on computer vision},
  pages={3072--3079},
  year={2013}
}
```
