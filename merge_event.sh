#!/bin/bash

# CONSTANTS AND VARIABLES
MODEL="reference"     # either 'event' or 'reference'
DATE=20150613   # keep in 8 digit format yyymmdd
# FILELIST=( lffd${DATE}{11..22}.nc ) # insert start and end time of event

# FILE PATHS
# Get Environment Paths
. ./file_paths.sh
OUT=${OUT}/merge_event.txt
OUTPUT=${EVENTS}/${DATE}/${MODEL}_${DATE}.nc
mkdir -p ${EVENTS}/${DATE}/

if [ "${MODEL}" == "reference" ]
then
    INPUT=`ls ${CCLM_OUT}/ref009/out02/lffd${DATE}{11..22}.nc`
    echo Scenario: reference 'no urban'!
    echo Scenario: reference 'no urban'! >> ${OUT}
elif [ "${MODEL}" == "event" ]
then
    INPUT=`ls ${CCLM_OUT}/ber009/out02/lffd${DATE}{11..22}.nc`
    echo Scenario: event 'urban'!
    echo Scenario: event 'urban'! >> ${OUT}
else
    echo Scenario not specified correctly! Choose 'event' or 'reference'!
    echo Scenario not specified correctly! Choose 'event' or 'reference'! >> ${OUT}
    exit 1
fi


# RECORD TIME
echo -e "$(date -u): Job started!\n" > ${OUT}
STARTTIME=$(date -u +%s)

# PROGRAM
cdo mergetime ${INPUT[*]} ${OUTPUT} >> ${OUT}

# RECORD ENDTIME
ENDTIME=$(date -u +%s)
echo -e "$(date -u): Finished Job in $((${ENDTIME} - ${STARTTIME})) seconds!" >> ${OUT}
