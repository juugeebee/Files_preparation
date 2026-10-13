echo ""
echo "bcl-convert.sh start"
echo ""


#***********************************************************************#
# BASE CALLING - BLC-CONVERT


run_dir=$(pwd)
output_dir="/media/jbogoin/Data3/Il-str-mRNA-D_NOVASEQ-Run6/Fastq"


if [ ! -f "$run_dir/SampleSheet.csv" ]; then
	echo "Erreur: File SampleSheet.csv was not found !"
	exit 1
fi


if [ -d "$run_dir/Fastq" ]; then
	rm -rf $output_dir
	echo "Output directory already exists. Remove previous Fastq/ folder and run bcl-convert."
fi


# bcl-convert --force --bcl-input-directory "$run_dir" --sample-sheet "$run_dir"/SampleSheet.csv \
# 	--output-directory "$run_dir"/Fastq/ --fastq-gzip-compression-level 5 --bcl-num-parallel-tiles 1

bcl-convert --force --bcl-input-directory "$run_dir" --sample-sheet "$run_dir"/SampleSheet.csv \
	--output-directory "$output_dir" --fastq-gzip-compression-level 5

#***********************************************************************#
# FASTQC


echo ""
echo "FastQC"
echo ""


conda activate fastqc


cd "$output_dir"

time parallel -j 16 fastqc {} ::: *.fastq.gz


mkdir -p ../QC/fastqc
mv *fastqc* ../QC/fastqc/

mv Logs ../QC
mv Reports ../QC 


conda deactivate


#***********************************************************************#
# TAGS RNU2


time /home/jbogoin/SCRIPTS/RNU2-2/rust/rnu2-tag-occurrences-mt/target/release/rnu2_tag_occurrences


cd ..


echo ""
echo "bcl-convert.sh job done!"
echo ""
