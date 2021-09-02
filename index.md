---
layout: default
title: SHORELine Benchmarking
parent: Documentation
has_children: false
has_toc: false
nav_order: 3
---

Running SHORELine on simulated and real data to show that it's really doing
head motion correction.

## Brief Project Description

SHORELine is a leave-one-out approach to head motion correction in diffusion-weighted
MRI. We need to make sure that it's able to detect and correct head motion. We are
able to generate realistic dMRI data with known ground-truth motion using the
FiberFox simulator.

## Project Lead(s)

Matt Cieslak

## Faculty Lead(s)

Ted Satterthwaite

## Analytic Replicator

TBD

## Collaborators

Phil Cook
Mark Elliott
Ariel Rokem
Divya Varadarajan
Scott Grafton

## Project Start Date

~2018

## Dataset

### Simulated dMRI data

Simulatd dMRI data were generated using the MITK Fiberfox tool. A docker image
containing FiberFox and some python scripts that enable it to simulate bval/bvecs
are available [on dockerhub](https://hub.docker.com/r/pennbbl/fiberfox). This
image was converted to singularity format and run on the crash cluster at UCSB
to create simulated DWIs with a number of configurations

|            | No Motion | Low Motion | High Motion |
| ---------- | --------- | ---------- | ----------- |
| Noise-Free |           |            |             |
| Realistic  |           |            |             |

Specifically, "Realistic" indicates that susceptibility distortion, Gaussian noise (noise variance of 251), eddy currents were included in the simulation (eddyStrength=0.01, eddyTau=70). "Noisefree" only included the
tissue response signal. For reference, the `High Motion` condition had a maximum translation
of 4mm in any direction and a maximum rotation of 8 degrees
about any axis. The `Low Motion` condition had a maximum translation of 2mm in any direction and maximum rotation of 3 degrees about any axis. Simulated motion in each image was
randomly drawn from a uniform distribution.

Otherwise, all simulations used the same scanning parameters. A single coil was simulated. Partial Fourier was not used. A repetition time of 4 seconds, with an echo time of 108ms was simulated. K-space simulation was used, with a k-space line offset of 0.1. No Gibbs ringing, ghosting, aliasing or signal spikes were simulated. Voxel size was 2mm.

The tissue model was based on the 77 fiber bundles included in
the ISMRM 2015 fiber tracking competition. Here is the section included
in the fiberfox parameter file:

```xml
    <compartments>
      <0>
        <type>fiber</type>
        <model>stick</model>
        <d>0.0011999999999999999</d>
        <t2>110</t2>
        <t1>0</t1>
        <ID>1</ID>
      </0>
      <1>
        <type>fiber</type>
        <model>tensor</model>
        <d1>0.0011999999999999999</d1>
        <d2>0.00029999999999999997</d2>
        <d3>0.00029999999999999997</d3>
        <t2>110</t2>
        <t1>0</t1>
        <ID>2</ID>
      </1>
      <2>
        <type>non-fiber</type>
        <model>ball</model>
        <d>0.001</d>
        <t2>80</t2>
        <t1>0</t1>
        <ID>3</ID>
      </2>
      <3>
        <type>non-fiber</type>
        <model>ball</model>
        <d>0.002</d>
        <t2>2500</t2>
        <t1>0</t1>
        <ID>4</ID>
      </3>
    </compartments>
```
Partial voluming effects were included in the simulation. The simulation data was
originally stored on the crash cluster and converted to BIDS format using `simulation/rename_simulations_to_bids.sh`. This resulted in a hierarchy of files looking like so:

```
├── noisefree
│   ├── highmotion
│   │   ├── sub-ABCD
│   │   │   ├── dwi
│   │   │   │   ├── sub-ABCD_acq-noisefree_run-highmotion_dwi.bval
│   │   │   │   ├── sub-ABCD_acq-noisefree_run-highmotion_dwi.bvec
│   │   │   │   ├── sub-ABCD_acq-noisefree_run-highmotion_dwi.json
│   │   │   │   └── sub-ABCD_acq-noisefree_run-highmotion_dwi.nii.gz
│   │   │   └── fmap
│   │   │       ├── sub-ABCD_dir-PA_epi.json
│   │   │       └── sub-ABCD_dir-PA_epi.nii.gz
│   │   ├── sub-DSIQ5
│   │   │   ├── anat
│   │   │   │   ├── sub-DSIQ5_T1w.json
│   │   │   │   └── sub-DSIQ5_T1w.nii.gz
│   │   │   ├── dwi
│   │   │   │   ├── sub-DSIQ5_acq-noisefree_run-highmotion_dwi.bval
│   │   │   │   ├── sub-DSIQ5_acq-noisefree_run-highmotion_dwi.bvec
│   │   │   │   ├── sub-DSIQ5_acq-noisefree_run-highmotion_dwi.json
│   │   │   │   └── sub-DSIQ5_acq-noisefree_run-highmotion_dwi.nii.gz
│   │   │   └── fmap
│   │   │       ├── sub-DSIQ5_dir-PA_epi.json
│   │   │       └── sub-DSIQ5_dir-PA_epi.nii.gz
│   │   ├── sub-HASC55
│   │   │   ├── anat
│   │   │   │   ├── sub-HASC55_T1w.json
│   │   │   │   └── sub-HASC55_T1w.nii.gz
│   │   │   ├── dwi
│   │   │   │   ├── sub-HASC55_acq-noisefree_run-highmotion_dwi.bval
│   │   │   │   ├── sub-HASC55_acq-noisefree_run-highmotion_dwi.bvec
│   │   │   │   ├── sub-HASC55_acq-noisefree_run-highmotion_dwi.json
│   │   │   │   └── sub-HASC55_acq-noisefree_run-highmotion_dwi.nii.gz
│   │   │   └── fmap
│   │   │       ├── sub-HASC55_dir-PA_epi.json
│   │   │       └── sub-HASC55_dir-PA_epi.nii.gz
│   │   ├── sub-HCP
│   │   │   ├── anat
│   │   │   │   ├── sub-HCP_T1w.json
│   │   │   │   └── sub-HCP_T1w.nii.gz
│   │   │   ├── dwi
│   │   │   │   ├── sub-HCP_acq-noisefree_run-highmotion_dwi.bval
│   │   │   │   ├── sub-HCP_acq-noisefree_run-highmotion_dwi.bvec
│   │   │   │   ├── sub-HCP_acq-noisefree_run-highmotion_dwi.json
│   │   │   │   └── sub-HCP_acq-noisefree_run-highmotion_dwi.nii.gz
│   │   │   └── fmap
│   │   │       ├── sub-HCP_dir-PA_epi.json
│   │   │       └── sub-HCP_dir-PA_epi.nii.gz
│   │   └── sub-PNC
│   │       ├── anat
│   │       │   ├── sub-PNC_T1w.json
│   │       │   └── sub-PNC_T1w.nii.gz
│   │       ├── dwi
│   │       │   ├── sub-PNC_acq-noisefree_run-highmotion_dwi.bval
│   │       │   ├── sub-PNC_acq-noisefree_run-highmotion_dwi.bvec
│   │       │   ├── sub-PNC_acq-noisefree_run-highmotion_dwi.json
│   │       │   └── sub-PNC_acq-noisefree_run-highmotion_dwi.nii.gz
│   │       └── fmap
│   │           ├── sub-PNC_dir-PA_epi.json
│   │           └── sub-PNC_dir-PA_epi.nii.gz
│   ├── lowmotion
│   │   ├── sub-ABCD
│   │   └── ...
│   └── nomotion
│       ├── sub-ABCD
│       └── ...
└── realistic
    ├── highmotion
    │   ├── sub-ABCD
    │   └── ...
    ├── lowmotion
    │   ├── sub-ABCD
    │   └── ...
    └── nomotion
        ├── sub-ABCD
        └── ...
```

each of the `.nii.gz` files are full of either high, low or no motion. The
exact motion parameters are stored in

### Simulated dMRI runs

## Github repo

Link to github repository for the project

## Path to data on filesystem

The Fiberfox simulations were run on the UCSB compute cluster and copied over to
CUBIC, CFN and dopamine.  The initial round of eddy testing was done on dopamine's
GPU. The initial round of SHORELine testing was done on cubic.

## Current work products

OHBM 2019 Poster

Nature Methods 2021

## Code documentation






