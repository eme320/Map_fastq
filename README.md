How to use

Save run_minimap2_ont.sh (e.g. in ~/bin or any folder).

Make it executable: in terminal:

chmod +x run_minimap2_ont.sh


Run it:

./run_minimap2_ont.sh


Then just paste:

the folder path (e.g. /Users/you/seqs/plasmid_ONT or ~/seqs/plasmid_ONT)

the reference filename (e.g. pCACNA1C.fa)

the ONT filename (e.g. barcode01.fastq.gz)

It will handle the rest and drop SAM + sorted BAM + index into that same folder.
