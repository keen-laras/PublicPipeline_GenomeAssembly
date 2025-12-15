genome="/path/to/{input}.fa"
#workdir="/workdir/"
hic_fq1="/path/to/{hic}_R1.fastq"
hic_fq2="/path/to/{hic}_R2.fastq"
chromap_bed="/path/to/{output}_chromap.bed"

/share/app/samtools/1.11/bin/samtools faidx ${genome}
/home/stereonote/yahs/yahs ${genome} ${chromap_bed} --no-contig-ec --no-scaffold-ec

/home/stereonote/yahs/juicer pre -a -o {output} yahs.out.bin yahs.out_scaffolds_final.agp ${genome}.fai
echo " YaHS is running"

ASM_SIZE=$(awk '{s+=$2} END{print s}' ${genome}.fai)
GENOME_ID="assembly ${ASM_SIZE}"
echo ${GENOME_ID} > genome_ID.txt

/share/app/java/jdk1.8.0_261/bin/java -jar -Xmx32G /home/stereonote/JuicerDir/scripts/common/juicer_tools.jar pre {output}.txt {output}.hic genome_ID.txt
echo "Processing .hic file"
