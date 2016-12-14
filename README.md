# napr
NAPR: A cloud-based framework for age prediction using neuroimaging

This repository contains code for a cloud-based system for predicting age from structural MRI, as implemented on www.cloudneuro.org.

The client directory contains a bash script to obtain age estimates from your own data.
The server directory contains the R package that is running on www.cloudneuro.org. This package takes Freesurfer surfaces as input to a predictive model and returns an age prediction.
The build.model directory contains scripts & data that were used to build the age prediction model.

To obtain age estimates from your own neuroimaging data you need the following:

1. A whole brain T1-weighted MRI scan that has been processed using the Freesurfer v5.3 default processing stream (recon-all)

2. Surfaces mapped to the fsaverage4 template. This typically takes < 1 minute per subject. 

  `recon-all -s subject.id -qcache -target fsaverage4`

3. The software package "curl".
 
  `sudo apt-get install curl`

4. [napr.sh] (https://github.com/hpardoe/napr/blob/master/client/napr.sh)

**Usage**

1. Set SUBJECTS_DIR as per standard Freesurfer processing
2. run `napr.sh subject.id`
