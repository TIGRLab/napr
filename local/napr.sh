#!/bin/bash

# A version of napr/client/napr.sh that runs fully locally

usage() {
    echo "Run NAPR locally. Please ensure SUBJECTS_DIR is set before running."
    echo ""
    echo "Usage: napr.sh [-a] subject_id"
    echo "       -a     Run using all available models. If absent, "
    echo "              only rvmm.full.20161228.model is used."
}

if [ -z "$SUBJECTS_DIR" ]
then
    usage
    exit
fi

MODEL=""

while getopts ":a:" opt; do
    case $opt in
        a)
            MODEL="all"
            shift
            ;;
        *) 
            usage
            exit
            ;;
    esac
done

SUBJ=$1
MYDIR=$PWD

LH_THICK=${SUBJECTS_DIR}/${SUBJ}"/surf/lh.thickness.fwhm0.fsaverage4.mgh"
RH_THICK=${SUBJECTS_DIR}/${SUBJ}"/surf/rh.thickness.fwhm0.fsaverage4.mgh"
if [ ! -f $LH_THICK ] || [ ! -f $RH_THICK ] ; then
  echo "File $LH_THICK or $RH_THICK not found."
  usage
  exit
fi

./report.age.R $LH_THICK $RH_THICK $MODEL