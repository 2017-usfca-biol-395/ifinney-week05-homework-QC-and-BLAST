# This bashscript will  use pipeline to run/output data from BLAST to our terminal
if [ -z ${BLASTDB} ]; then source /home/.bashrc; export PATH; export BLASTDB; fi

#Note: For this next command, the pipe and tail -n +2 is a handy way to exclude the first line

for SRA_number in $(cut -f 6 data/metadata/fierer_forensic_hand_mouse_SraRunTable.txt | tail -n +2)
do
	fastq-dump -v $SRA_number -O data/raw_data
done

# This runs QC reports
fastqc data/raw_data/*.fastq --outdir=output/fastqc

#Make a directory to dump the trimmed sequences in
mkdir data/trimmed_seq

for file in data/raw_data/*.fastq
do 
	TrimmomaticSE -threads 2 -phred33 $file data/trimmed/$(basename -s .fastq $file).trim.fastq LEADING:5 TRAILING:5 SLIDINGWINDOW:8:25 MINLEN:150
done

#Make a directory to dump trim.fasta files in
mkdir data/fasta_seq
for file in data/trimmed_seq/*.trim.fastq 
do
	bioawk -c fastx '{print ">"$name"\n"$seq}' data/trimmed_seq/*.trim.fastq >  data/fasta_seq/$(basename -s .trim.fastq $file).trim.fasta
done

#Make a directory to output BLAST results
mkdir output/blast

for file in data/fasta_seq/ERR1942280.trim.fasta
do 
	echo "BLASTing"
	blastn -db /blast-db/nt -num_threads 2 -outfmt '10 sscinames std' -out output/blast/$(basename -s .fasta $file).csv -max_target_seqs 1 -negative_gilist /blast-db/2017-09-21_GenBank_Environmental_Uncultured_to_Exclude.txt -query $file
	echo "Finished downloading BLAST results"
done
