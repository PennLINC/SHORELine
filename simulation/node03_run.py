#!/usr/bin/env python
from __future__ import print_function
from copy import deepcopy

from simulate_motion_scheme import simulate, default_args
import os.path as op
import os

output_root = '/home/mcieslak/projects/fiberfox_simulations'
gradient_root = '/home/mcieslak/projects/fiberfox-wrapper/gradients'

simulation_specs = {
    'motion':{
        'doAddMotion': 'true',
        'randomMotion': 'true',
        'translation0': 2,
        'translation1': 2,
        'translation2': 2,
        'rotation0': 3,
        'rotation1': 3,
        'rotation2': 3
        },
    'highmotion':{
        'doAddMotion': 'true',
        'randomMotion': 'true',
        'translation0': 4,
        'translation1': 4,
        'translation2': 4,
        'rotation0': 8,
        'rotation1': 8,
        'rotation2': 8
        },
    'noise':{
        'addnoise': 'true',
        'noisetype': 'gaussian',
        'noisevariance': 251,
        },
    'eddy':{
        'addeddycurrents': 'true',
        'eddyStrength': 0.01,
        'eddyTau': 70
        },
    'susc': {
        'doAddDistortions': 'true'
        }
}

gradients = {
    "HCP": "hcp_multishell",
    "DSI_Q5": "Q5_dsi",
    "ABCD": "abcd",
    "HASC55_V1": "HASC55_v1_csdsi",
    "HASC55_V2": "HASC55_v2_csdsi",
    "HASC92": "HASC92_csdsi",
    "RAND57": "RAND57_csdsi"
    }

to_simulate = {
    "realistic_lowmotion": ['motion', 'noise', 'eddy', 'susc'],
    "realistic_highmotion": ['highmotion', 'noise', 'eddy', 'susc'],
    "realistic_nomotion": ['noise', 'eddy', 'susc']
}

#seqs_to_run = ["DSI_Q5", "ABCD", "HASC55_V1"][::-1]
seqs_to_run = ["HASC55_V1"]
sims_to_run = ['realistic_nomotion', 'realistic_highmotion', 'realistic_lowmotion']


for seq_name in seqs_to_run:
    for sim_name in sims_to_run:
        print("##########################", seq_name, sim_name, "##########################" )
        output_dir = op.join(
            op.join(output_root, seq_name),
            sim_name)
        # Skip if it's been run
        if op.exists(op.join(output_dir, 'fiberfox.nii.gz')): continue

        if not op.exists(output_dir):
            os.makedirs(output_dir)
        grad = op.join(gradient_root, gradients[seq_name])
        bval = grad + ".bval"
        bvec = grad + ".bvec"

        params = deepcopy(default_args)
        for spec in to_simulate[sim_name]:
            params.update(simulation_specs[spec])

        simulate(bvec, bval, output_dir=output_dir,
                 singularity_image="/crash-work/containers/fiberfox.simg", **params)
