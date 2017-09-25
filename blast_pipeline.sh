# This bashscript will  use pipeline to run/output data from BLAST to our terminal
if [ -z ${BLASTDB} ]; then source /home/.bashrc; fi

#Note: For this next command, the pipe and tail -n +2 is a handy way to exclude the first line

for SRA_number in $(cut -f 6 data/metadata/fierer_forensic_hand_mouse_SraRunTable.txt | tail -n +2)
do
	echo fastq-dump -v $SRA_number -O data/raw_data
done

# This runs QC reports
echo fastqc data/raw_data/*.fastq --outdir=output/fastqc

echo mkdir data/trimmed_seq

for file in data/raw_data/*.fastq
do 
	TrimmomaticSE -threads 2 -phred33 $file data/trimmed/$(basename -s .fastq $file).trim.fastq LEADING:5 TRAILING:5 SLIDINGWINDOW:8:25 MINLEN:150
done

#for a file in 
#do
#	bioawk -c fastx '{print ">"$name"\n"$seq}' data/trimmed/filename.trim.fastq
#done
