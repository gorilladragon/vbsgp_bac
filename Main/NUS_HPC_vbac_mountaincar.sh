#!/bin/bash
#BSUB -o vbac_outfile
#BSUB -e vbac_errorfile
#BSUB -q serial

matlab <vbac_mountain_car.m> vbac_displayMatlab.out

