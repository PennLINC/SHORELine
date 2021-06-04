---
layout: default
title: SHORELine Benchmarking
parent: Documentation
has_children: false
has_toc: false
nav_order: 3
---

# SHORELine Validation and Benchmarking

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

Specifically, "Realistic" indicates that susceptibility distortion, rician noise, Gibbs
ringing and eddy currents were included in the simulation. "Noisefree" only included the
tissue response signal. For reference, the


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






