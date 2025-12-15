#!/usr/bin/env bash
set -euo pipefail

echo "=== Nanopore → plasmid alignment helper ==="
echo

#############################################
# 1) Ask for folder
#############################################

read -r -p "Paste the folder where ref and ONT files are stored: " seq_folder
if [ -z "$seq_folder" ]; then
  echo "ERROR: Folder path cannot be empty." >&2
  exit 1
fi

# Strip surrounding single/double quotes if present (Finder “Copy as Pathname”)
seq_folder="${seq_folder%\"}"
seq_folder="${seq_folder#\"}"
seq_folder="${seq_folder%\'}"
seq_folder="${seq_folder#\'}"

# Expand leading ~ to $HOME
seq_folder="${seq_folder/#\~/$HOME}"

# Remove trailing slash, if any
seq_folder="${seq_folder%/}"

if [ ! -d "$seq_folder" ]; then
  echo "ERROR: Folder does not exist: $seq_folder" >&2
  exit 1
fi

echo
echo "Folder set to: $seq_folder"
echo "Files in folder (preview):"
ls "$seq_folder" || true
echo

#############################################
# 2) Ask for filenames
#############################################

read -r -p "Paste the reference FASTA filename (e.g. plasmid.fa): " ref_seq
if [ -z "$ref_seq" ]; then
  echo "ERROR: Reference filename cannot be empty." >&2
  exit 1
fi

read -r -p "Paste the ONT FASTQ filename (e.g. reads.fastq.gz): " ont_seq
if [ -z "$ont_seq" ]; then
  echo "ERROR: ONT filename cannot be empty." >&2
  exit 1
fi

ref_path="${seq_folder}/${ref_seq}"
ont_path="${seq_folder}/${ont_seq}"

#############################################
# 3) Check dependencies + inputs
#############################################

if ! command -v minimap2 >/dev/null 2>&1; then
  echo "ERROR: minimap2 not found in PATH. Install via e.g. 'brew install minimap2'." >&2
  exit 1
fi

if ! command -v samtools >/dev/null 2>&1; then
  echo "ERROR: samtools not found in PATH. Install via e.g. 'brew install samtools'." >&2
  exit 1
fi

if [ ! -f "$ref_path" ]; then
  echo "ERROR: Reference sequence not found: $ref_path" >&2
  exit 1
fi

if [ ! -f "$ont_path" ]; then
  echo "ERROR: ONT reads file not found: $ont_path" >&2
  exit 1
fi

#############################################
# 4) Build output names
#############################################

ref_base=$(basename "$ref_seq")
ref_root=${ref_base%%.*}      # strip extension(s)

ont_base=$(basename "$ont_seq")
ont_base=${ont_base%.gz}
ont_base=${ont_base%.fastq}
ont_base=${ont_base%.fq}
ont_root=${ont_base%%.*}

out_sam="${seq_folder}/${ont_root}_vs_${ref_root}.sam"
out_bam="${seq_folder}/${ont_root}_vs_${ref_root}.sorted.bam"

echo
echo "Reference: $ref_path"
echo "Reads:     $ont_path"
echo "SAM out:   $out_sam"
echo "BAM out:   $out_bam"
echo

read -r -p "Proceed with alignment? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted by user."
  exit 0
fi

#############################################
# 5) Run minimap2 + samtools
#############################################

echo
echo "Running minimap2 + samtools..."
echo

minimap2 -ax map-ont --secondary=no "$ref_path" "$ont_path" \
  | tee "$out_sam" \
  | samtools view -bS - \
  | samtools sort -o "$out_bam"

samtools index "$out_bam"

echo
echo "Done."
echo "  SAM : $out_sam"
echo "  BAM : $out_bam"
echo "  BAI : ${out_bam}.bai"
echo
