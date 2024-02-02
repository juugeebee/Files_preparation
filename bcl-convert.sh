echo ""
echo "bcl-convert.sh start"
echo ""


run_dir=$(pwd)


if [ ! -f "$run_dir/SampleSheet.csv" ]; then
	echo "Erreur: File SampleSheet.csv was not found !"
	exit 1
fi


if [ -d "$run_dir/Fastq" ]; then
	rm -rf $run_dir/Fastq
	echo "Output directory already exists. Remove previous Fastq/ folder and run bcl-convert."
fi


bcl-convert --force --bcl-input-directory "$run_dir" --sample-sheet "$run_dir"/SampleSheet.csv --output-directory "$run_dir"/Fastq/ --fastq-gzip-compression-level 5


cd Fastq/
bash ~/SCRIPTS/Files_preparation/cat_fastq.sh 


echo ""
echo "bcl-convert.sh job done!"
echo ""