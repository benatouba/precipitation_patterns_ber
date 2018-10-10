#!/bin/bash

# PATHS AND FILES
# export file paths from locally stored file
. ./file_paths.sh

echo ${ERA5_SCRT}
cd ${ERA5_SCRT}
OUT=${OUT}/copy_era5.txt

# OPTIONS
COMPR=0

# RECORD TIME
echo -e "$(date -u): Job started!\n" > ${OUT}
STARTTIME=$(date -u +%s)

# PROGRAM
for i in ${ERA5_FRC}/caf20130[5-8]*; do
    SECONDS=0

    echo -e "$(date -u):\nnccopy\n${i}\nto\n\
${ERA5_SCRT}$(basename -s .nc ${i}).nc\n" >> ${OUT}

    nccopy -d ${COMPR} ${i} $(basename -s .nc ${i}).nc

    echo -e "$(date -u):\nDone with file\n\
$(basename -s .nc ${i}).nc\nin\ntime = ${SECONDS} seconds!\n" >> ${OUT}
done

# RECORD ENDTIME
ENDTIME=$(date -u +%s)
echo -e "$(date -u): Finished Job in $((${ENDTIME} - ${STARTTIME})) seconds!" >> ${OUT}
