echo ""
echo "bcl-convert.sh start"
echo ""


#***********************************************************************#
# BASE CALLING - BLC-CONVERT


run_dir=$(pwd)


if [ ! -f "$run_dir/SampleSheet.csv" ]; then
	echo "Erreur: File SampleSheet.csv was not found !"
	exit 1
fi


if [ -d "$run_dir/Fastq" ]; then
	rm -rf $run_dir/Fastq/
	echo "Output directory already exists. Remove previous Fastq/ folder and run bcl-convert."
fi


bcl-convert --force --bcl-input-directory "$run_dir" --sample-sheet "$run_dir"/SampleSheet.csv \
	--output-directory "$run_dir"/Fastq/ --fastq-gzip-compression-level 5 --bcl-num-parallel-tiles 1



#***********************************************************************#
# FASTQC


echo ""
echo "FastQC"
echo ""


conda activate fastqc

mv Fastq ../
cd ../Fastq


time parallel -j 16 fastqc {} ::: *.fastq.gz


mkdir -p ../QC/fastqc
mv *fastqc ..QC/fastqc/

mv Logs ../QC
mv Reports ../QC 


conda deactivate


#***********************************************************************#
# TAGS RNU2


time /home/jbogoin/SCRIPTS/RNU/rust/rnu2-tag-occurrences-mt/target/release/rnu2_tag_occurrences


cd ..


echo ""
echo "bcl-convert.sh job done!"
echo ""
