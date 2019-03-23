#!/bin/bash
# T1 segmentation with yuki 2.1 (part of ART)
# yuki requires openmpi installed
# identify the paths to T1 weighted images
find . -iname "t1_brain.nii.gz" >> anat
#yuki 2.2 processing of the ABCD training data
# convert to format suitable for yuki, uncompress, segment and compress the data
while read img ; do img_noext=`echo $img | sed 's/\.nii\.gz//g'` ; 
  fslmaths ${img}  ${img_noext}_short -odt short ; 
  gunzip ${img_noext}_short.nii.gz  ; 
  yuki -i ${img_noext}_short.nii -v -W -Hampel -csv  ${img_noext}_short.csv ; 
  gzip ${img_noext}_short.nii ; 
done < anat
# extracting the results
# identify all the results files for all processed subjects
find . -iname "*.csv" | sort >> list_results
# identify the first entry to create a header
cat list_results | head -1 >> header
# export the first line of header to the results file
while read results ; do cat $results | awk NR==1 >> results_v1.csv ; done < header 
# export the data from all the files listed in the list_results file
while read results ; do cat $results | awk NR==2 >> results_v1.csv ; done < list_results 
#
# in case it is neccesary remove unnecessary parts using cat sed combination
# that's it folks
exit
