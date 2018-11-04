#This for loop will parse out the the name and number of sequences of all BLAST csv files
# 1st: It will find all files with *_blast_results.csv
# 2nd: It will take those files and parse out the names & sequence numbers in each csv file and then output the results (using a unique sorting order)
	#"sort -r" sorts the output by highest numerical first 
# 3rd: It will dump these results into new files called ${run_id}_blast_summary.csv into a new directory named compiled_blast_summary_results

#Note: This script is located within my output directory so this is why I did not need to add in "output/" when referencing or moving dirctories


for run_id in blast/*_blast_results.csv
do
	cut -d "," -f1 ${run_id} | sort | uniq -c | sort -r > compiled_blast_summary_results/$(basename -s .csv ${run_id})_summary.csv
done

