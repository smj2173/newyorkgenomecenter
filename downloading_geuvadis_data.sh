#!/bin/bash
#june 12, 2020
#author: sophie johnson

cut -f1 geuvadis_data_info.tsv > new_data.tsv

output_dir=/gpfs/commons/groups/knowles_lab/big_blast/datasets/geuvadis/

while read line; do
    wget -P $output_dir $line
done < new_data.tsv
 
#future note: look at resource to do some processing of line $i
