#!/bin/bash
# take subject ID and return measurement
# SUBJECTS_DIR needs to be defined
# 
# need to do the two steps below to get tar to work properly on Macs
COPYFILE_DISABLE=1
export COPYFILE_DISABLE

SUBJ=$1

MYDIR=$PWD
cd $SUBJECTS_DIR
LH_THICK=$SUBJ"/surf/lh.thickness.fwhm0.fsaverage4.mgh"
RH_THICK=$SUBJ"/surf/rh.thickness.fwhm0.fsaverage4.mgh"
echo $SUBJ > sub_id.txt
tar -czf /tmp/.cloudneuro_tar.gz $LH_THICK $RH_THICK sub_id.txt
cd $MYDIR

curl -L https://cloudneuro.org/ocpu/library/napr/R/report.age -F "file=@/tmp/.cloudneuro_tar.gz" -o /tmp/.napr_response -# >> /dev/null

SESSION_ID=`head -n1 /tmp/.napr_response | cut -f4 -d/`
echo $SESSION_ID

curl -L https://cloudneuro.org/ocpu/tmp/$SESSION_ID/stdout
