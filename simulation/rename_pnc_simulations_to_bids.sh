#!/usr/bin/env bash

json_maker=make_jsons.py
motion_grabber=grab_motion.py
copy_to() {
  img=$1
  bval=${1/nii.gz/ffp.bvals}
  bvec=${1/nii.gz/ffp.bvecs}
  log=${1/nii.gz/log}
  prefix=$2

  outdir=`dirname $prefix`
  mkdir -p $outdir

  if [ ! -f ${prefix}.nii.gz ];
  then
    cp -p $img ${prefix}.nii.gz
    cp -p $bval ${prefix}.bval
    cp -p $bvec ${prefix}.bvec
    python ${json_maker} ${prefix}.nii.gz
    #python ${motion_grabber} ${log} ${prefix}
  fi

}

ref_t1w=anat/sub-HCP_T1w.nii.gz
ref_json=anat/sub-HCP_T1w.json
link_anat(){
  newfile=$1

  outdir=`dirname $newfile`
  mkdir -p $outdir
  if [ ! -f ${newfile} ]; then
      cp ${ref_t1w} ${newfile}.nii.gz
      cp ${ref_json} ${newfile}.json
  fi

}

function shuffle(){
    inpth=$1
    fname=`basename $inpth`
    fdir=`dirname $inpth`
    newf=`echo $fname | sed 's/sub-\([A-Z][A-Z0-9]*\)_acq-\([a-z][a-z]*\)_run-\([a-z][a-z]*\)_\(.*\)$/sub-\1_acq-\2X\3_\4/'`
    if [[ ! "${fname}" == "${newf}" ]]; then
        mv $inpth ${fdir}/${newf}
    fi
}


for scheme in HASC55 DSIQ5 HCP ABCD PNC
do
    tar cvfJ ${scheme}.tar.xz */*/sub-${scheme} */*/*json */*/README
done

BASE=`pwd`/BIDS_datasets

# low motion, noise free
lowmot=${BASE}/rpe_noisefree/lowmotion
copy_to PNCDTI/rpe_noisefree_lowmotion/fiberfox_0.nii.gz \
    ${lowmot}/sub-PNC/dwi/sub-PNC_acq-noisefree_run-lowmotion_dwi
link_anat  \
    ${lowmot}/sub-PNC/anat/sub-PNC_T1w

# High motion, noise free
highmot=${BASE}/rpe_noisefree/highmotion
copy_to PNCDTI/rpe_noisefree_highmotion/fiberfox.nii.gz \
    ${highmot}/sub-PNC/dwi/sub-PNC_acq-noisefree_run-highmotion_dwi
link_anat  \
    ${highmot}/sub-PNC/anat/sub-PNC_T1w

# No motion, noise free
noisefree=${BASE}/rpe_noisefree/nomotion
copy_to PNCDTI/rpe_noisefree_nomotion/fiberfox.nii.gz \
    ${noisefree}/sub-PNC/dwi/sub-PNC_acq-noisefree_run-nomotion_dwi
link_anat  \
    ${noisefree}/sub-PNC/anat/sub-PNC_T1w


# No motion, realistic noise
nomotionnoisy=${BASE}/rpe_realistic/nomotion
copy_to PNCDTI/rpe_realistic_nomotion/fiberfox.nii.gz \
    ${nomotionnoisy}/sub-PNC/dwi/sub-PNC_acq-realistic_run-nomotion_dwi
link_anat  \
    ${nomotionnoisy}/sub-PNC/anat/sub-PNC_T1w

# high motion, realistic noise
highmotionnoisy=${BASE}/rpe_realistic/highmotion
copy_to PNCDTI/rpe_realistic_highmotion/fiberfox.nii.gz \
    ${highmotionnoisy}/sub-PNC/dwi/sub-PNC_acq-realistic_run-highmotion_dwi
link_anat  \
    ${highmotionnoisy}/sub-PNC/anat/sub-PNC_T1w

# low  motion, realistic noise
lowmotionnoisy=${BASE}/rpe_realistic/lowmotion
copy_to PNCDTI/rpe_realistic_lowmotion/fiberfox.nii.gz \
    ${lowmotionnoisy}/sub-PNC/dwi/sub-PNC_acq-realistic_run-lowmotion_dwi
link_anat  \
    ${lowmotionnoisy}/sub-PNC/anat/sub-PNC_T1w

