
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
framework for the task of facial landmark localization.
Fig. 1 depicts the scheme of the proposed framework. In
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


 ![](http://www.hamedkiani.com/uploads/5/1/8/8/51882963/edited/bacf-2.png?1505151342)

<br>

## Evaluation result

#### (I) Success plots comparing BACF with the state-of-the-art HOG based trackers on (a) OTB50, (b) OTB100, and (c) TC128. The result of top 12 trackers is illustrated here. AUCs are reported in brackets.

![](http://www.hamedkiani.com/uploads/5/1/8/8/51882963/screen-shot-2017-09-11-at-1-40-00-pm_orig.png)

<br><br>

###  (II) Attribute based evaluation. Success plots compare BACF with state-of-the-art HOG based trackers on OTB100. BACF outperformed all the trackers over all attributes. AUCs are reported in brackets. The number of videos for each attribute is shown in parenthesis.

![](http://www.hamedkiani.com/uploads/5/1/8/8/51882963/screen-shot-2017-09-11-at-1-50-35-pm_orig.png)

<br><br>

### (III) Success rates (% at IoU > 0.50) of BACF compared to CF trackers with deep features

![](http://www.hamedkiani.com/uploads/5/1/8/8/51882963/screen-shot-2017-09-11-at-1-45-41-pm_orig.png)

<br><br>

### (IV) Tracking demo on OTB-100 dataset

[![](http://img.youtube.com/vi/aertxlzMEPo/0.jpg)](http://www.youtube.com/watch?v=aertxlzMEPo "")


<br><br>

### (V) Tracking result (MAT files) for OTB-50 and OTB-100​

### http://www.hamedkiani.com/bacf.html

<br>

## Running instructions

coming soon!

## Reference

```
@inproceedings{kiani2017learning,
  title={Learning background-aware correlation filters for visual tracking},
  author={Kiani Galoogahi, Hamed and Fagg, Ashton and Lucey, Simon},
  booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
  pages={1135--1143},
  year={2017}
}
```
