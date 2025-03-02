#!/bin/bash -eux
# align pacbio runs with minimap2

grep PACBIO human_long_read_datasets.tsv | cut -f 1| while read acc; do 
  if [ -f $acc.bam ] ; then continue; fi; 
  if [ ! -f $acc.fasta ] ; then fastq-dump --fasta $acc; fi;
  size=$(du -b $acc.fasta | cut -f 1)
  if (( size > 100000000 )) ; then 
    echo Too big: $acc $size
    continue; 
  fi
  minimap2 -ax splice -C5 --eqx GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.map-pb.mmi $acc.fasta | samtools view -Sb - | samtools sort - > $acc.bam;  samtools index $acc.bam; 
done
