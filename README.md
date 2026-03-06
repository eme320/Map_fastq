How to use

Save run_minimap2_ont.sh (e.g. in ~/bin or any folder).

Make it executable: in terminal:
cd ~/Downloads/  - if your file is in downloads
chmod +x run_minimap2_ont.sh


Run it:

./run_minimap2_ont.sh

if no brew, run following:
  
  xcode-select
  ruby -e “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)” (asks for Kerberos ID)
 OR
 \/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" (asks for Kerberos ID)
  brew install minimap2 (to install minimap)
  brew install samtools (to install samtools)

Then just paste:

the folder path (e.g. /Users/you/seqs/plasmid_ONT or ~/seqs/plasmid_ONT)

the reference filename (e.g. pCACNA1C.fa)

the ONT filename (e.g. barcode01.fastq.gz)

It will handle the rest and drop SAM + sorted BAM + index into that same folder.
