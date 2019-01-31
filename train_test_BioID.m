


%   The implementation of the WACV'16 paper: Correlation Filter Cascade for Facial Landmark Localization
%   By: Hamed Kiani (hamedkg@gmail.com) -- http://www.hamedkiani.com
%   June 2016


clc, clear, close all;
%% Cascade correlation filter training and testing
%  BioID  dataset (1521 images)

% index of the landmark of interest (1:19):
% 1 = right eye pupil
% 2 = left eye pupil
% 3 = right mouth corner
% 4 = left mouth corner
% 5 = outer end of right eye brow
% 6 = inner end of right eye brow
% 7 = inner end of left eye brow
% 8 = outer end of left eye brow
% 9 = right temple
% 10 = outer corner of right eye
% 11 = inner corner of right eye
% 12 = inner corner of left eye
% 13 = outer corner of left eye
% 14 = left temple
% 15 = tip of nose
% 16 = right nostril
% 17 = left nostril
% 18 = centre point on outer edge of upper lip
% 19 = centre point on outer edge of lower lip

%   No of cascade levels: 5, [128x128 64x64 32x32 16x16 8x8], any number of
%   levels can be used in this code.
no_level = 5;
%   index of landmark of interest, change it accordingly for each landmark
lm_inds  =  19; %    1:19;

%   th = 0.1 of the ocular distance, which is the distanec between the right and left eye centers
%   detection with error less than th is considered as a successful detection
th = 0.1;

%   feature parameters
feat.type   = 2;            % hog:1, gabor+soble+gray : 2, hog+gabor : 3, gray:4, Sobel : 5, Gabor : 6, Gabor + Gray : 7, Gabor+sobel:8
feat.nbins  = 6;            % # of hog bins
feat.sigma  = 2;            % sigma of the gaussian-like correlation output
feat.lambda =  1;           % regularization value
feat.cell_size =  [6 6];    % cell size for computing hog
feat.block_size = [6 6];    % block size for computing hog

feat.pn  = 1;               % 1 : apply power normalized, 0 : no normalization (defualt = 1)
feat.cw  = 1;               % 1: cosine windowing, 0 : no cosine wondowing (default = 1)
feat.gSz = [21 21];         % the Gabor filter size
feat.gO  = 8;               % # of Gabor orientations
feat.gS  = 5;               % # of Gabor scales
feat.wol = 1 ;              % extracting feature from whole face image or cropped:
% 1 for whole face, 0 for limited boundaries

imSz  = [128 128];          % indicates the image size, all BioID images in the mat file is normalized to be [128 128]
fltSz = [128 128; 64 64; 32 32; 16 16; 8 8];          % the largest filter size, any size can be used in this code

assert(no_level == size(fltSz,1),'The number of filters is not correctly set!' );
%   control training and testing
%   the cascade for landmark=19 is already trained. So for test, use the
%   following setting:
do_train = 0;
do_test  = 1;
%   to train for another landmark, just change the "lm_inds" above, and set
%   do_train = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   training and testing random sampling, 1000 samples for training, the
%   rest for testing.

%   loading all BioID images: imgs
load('BioID_imgs','imgs');
imgs_ind  = randperm(numel(imgs));

if (exist('test_ind.mat'))
    load('test_ind.mat','test_ind');
else
    test_ind  = imgs_ind(1001:end);
end;
if (exist('train_ind.mat'))
    load('train_ind.mat','train_ind');
else
    train_ind  = imgs_ind(1:1000);
end;

%   train the cascade
if do_train
    
    %   loading training BioID images, training filters and save them
    train_imgs = imgs(train_ind);
    for i = 1:no_level
        filt = train_filter(train_imgs, lm_inds, imSz, fltSz(i,:), feat);
        save(['Gabor40_Sobel2_Gray1/' num2str(fltSz(i,1)) '.mat'], 'filt');
    end;
    
end;
%   test it!
if do_test
    test_imgs = imgs(test_ind);
    %     true_localization : localization accuracy over all test images
    %     localization_error: localization error in pixel, normalized by
    %     the ocular distance of each image.
    [true_localization localization_error] = test_filter(test_imgs, lm_inds, feat, imSz, fltSz, th);
    %   fig 5 in the paper
    display(['The average localization error for landmark # ' num2str(lm_inds) ' is :' num2str(localization_error)]);
    %   fig 6 in the paper
    display(['The localization accuracy for landmark # ' num2str(lm_inds) ' is      :' num2str(true_localization)]);
    
    %   Please note that the accuracy and localization error achieved here
    %   might be slightly different than those reported in the paper, due
    %   to random sampling of the training and testing set. The result in
    %   the paper is the average of 10 random runs!
end;

