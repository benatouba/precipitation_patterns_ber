#!/bin/bash

# PATHS AND FILES
DEST_PATH='/data/scratch/smidbenq/era5/'
SOURCE_PATH='/data/projects/ensembles/era5/analysis/cclm_forcing/year2013/'
cd ${DEST_PATH}
touch out.txt

# OPTIONS
COMPR=0

# RECORD TIME
echo -e "$(date -u): Job started!\n" > out.txt
STARTTIME=$(date -u +%s)

# PROGRAM
for i in ${SOURCE_PATH}/caf20130[5-8]*; do
    SECONDS=0

    echo -e "$(date -u):\nnccopy\n${i}\nto\n\
${DEST_PATH}$(basename -s .nc ${i}).nc\n" >> out.txt

    nccopy -d ${COMPR} ${i} $(basename -s .nc ${i}).nc

    echo -e "$(date -u):\nDone with file\n\
$(basename -s .nc ${i}).nc\nin\ntime = ${SECONDS} seconds!\n" >> out.txt
done

# RECORD ENDTIME
ENDTIME=$(date -u +%s)
echo -e "$(date -u): Finished Job in $((${ENDTIME} - ${STARTTIME})) seconds!" >> out.txt
