#!/bin/bash
# wish list:
# -a return results using all available models
# -v return script version
# -h return help
# if just a subject.id is specified, return age prediction using default model
# -l return list of available models
# -m model.id return age prediction using model.id

while getopts ":a:" opt; do
  case $opt in
    a)
      #echo "-a was triggered, Parameter: $OPTARG" >&2
      COPYFILE_DISABLE=1
      export COPYFILE_DISABLE

      SUBJ=$OPTARG

      MYDIR=$PWD
      cd $SUBJECTS_DIR
      LH_THICK=$SUBJ"/surf/lh.thickness.fwhm0.fsaverage4.mgh"
      RH_THICK=$SUBJ"/surf/rh.thickness.fwhm0.fsaverage4.mgh"
      if [ ! -f $LH_THICK ] || [ ! -f $RH_THICK ] ; then
        echo "File $LH_THICK or $RH_THICK not found"
        exit
      fi
      echo $SUBJ > sub_id.txt
      tar -czf /tmp/.cloudneuro_tar.gz $LH_THICK $RH_THICK sub_id.txt
      cd $MYDIR

      curl -L https://cloudneuro.org/ocpu/library/napr/R/report.age.multiple.models -F "file=@/tmp/.cloudneuro_tar.gz" -o /tmp/.napr_response -# >> /dev/null

      SESSION_ID=`head -n1 /tmp/.napr_response | cut -f4 -d/`
      echo $SESSION_ID

      curl -L https://cloudneuro.org/ocpu/tmp/$SESSION_ID/stdout
      exit
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

COPYFILE_DISABLE=1
export COPYFILE_DISABLE

SUBJ=$1

MYDIR=$PWD
cd $SUBJECTS_DIR
LH_THICK=$SUBJ"/surf/lh.thickness.fwhm0.fsaverage4.mgh"
RH_THICK=$SUBJ"/surf/rh.thickness.fwhm0.fsaverage4.mgh"
if [ ! -f $LH_THICK ] || [ ! -f $RH_THICK ] ; then
  echo "File $LH_THICK or $RH_THICK not found"
  exit
fi
echo $SUBJ > sub_id.txt
tar -czf /tmp/.cloudneuro_tar.gz $LH_THICK $RH_THICK sub_id.txt
cd $MYDIR

curl -L https://cloudneuro.org/ocpu/library/napr/R/report.age -F "file=@/tmp/.cloudneuro_tar.gz" -o /tmp/.napr_response -# >> /dev/null

SESSION_ID=`head -n1 /tmp/.napr_response | cut -f4 -d/`
echo $SESSION_ID

curl -L https://cloudneuro.org/ocpu/tmp/$SESSION_ID/stdout
