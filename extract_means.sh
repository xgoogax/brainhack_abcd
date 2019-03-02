#!/bin/bash
#

# extracting mean and st deviation for roi 
# Hanna Nowicka, Brainhack Warsaw, March 2019


dir='..' # where your T1s data is
tmp_dir='temp' # just temp dir for auxiliary files 

mkdir ${dir}/${tmp_dir}

#i=33 # for i in whatever is in atlas do

for i in $(seq 134);
        do
        # single out the ROI out of the parcellation:
        fslmaths ${dir}/t1_gm_parc.nii.gz -thr $(echo "$i - 0.5" | bc)  -uthr  $(echo "$i + 0.5" | bc) -bin ${dir}/${tmp_dir}/tmp_region.nii.gz

        # extract mean from that T1 masked by the single region:
        mean=`fslstats ${dir}/t1_brain.nii.gz  -k ${dir}/${tmp_dir}/tmp_region.nii.gz  -M | awk '{print $1}'`
        # extract st deviation:
        stdev=`fslstats ${dir}/t1_brain.nii.gz  -k ${dir}/${tmp_dir}/tmp_region.nii.gz  -S | awk '{print $1}'`
        echo -n $mean >> ${dir}/means.txt
        echo -n "," >> ${dir}/means.txt
        echo $stdev  >> ${dir}/stdevs.txt
        echo -n "," >> ${dir}/stdevs.txt

        rm -r ${dir}/${tmp_dir}

done
