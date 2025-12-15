source ~/.bashrc
conda activate /HiC-Pro

echo "Starting HiC-Pro"
cd /workdir/
/HiC-Pro -i /path/to/{hic_files} -o /path/to/{outputdir} -c config.txt 
echo"HiC-Pro finished"

echo "Convert bed file from Bam file for downstream yahs analysis"

/samtools view -bh -F 0xF0C -q 0 /path/to/{outputdir}/bowtie_results/bwt2/fastq/{HiCpro_output}_index.bwt2pairs.bam | \
/bedtools bamtobed | \
  awk -v OFS='\t' '{$4=substr($4,1,length($4)-2); print}' \
  > {output}.bed

echo "Bed file has been generated for downstream YaHS analysis"
