#!/bin/bash


echo "[START] Pore-C scaffolding + Juicebox"
echo "Start time: $(date)"

# ========================== PARAMETER ==========================
REFERENCE_GENOME="{input}.fasta"
BED_FILE="{bowtie_result}.bed"  
OUTPUT_PREFIX="{output}"
export _JAVA_OPTIONS="-Xmx32G"

# SOFTWARE
YAHS="/opt/software/mambaforge/envs/yahs/bin/yahs"
SAMTOOLS="/opt/software/mambaforge/envs/yahs/bin/samtools"
JUICER_PRE="/opt/software/mambaforge/envs/yahs/bin/juicer"
JUICER_TOOLS="/opt/software/mambaforge/envs/yahs/bin/juicer_tools"


# ========================== INDEX ==========================
echo "[Step 1] Indexing reference genome..."
${SAMTOOLS} faidx ${REFERENCE_GENOME}

# ========================== YaHS SCAFFOLDING ==========================
echo "[Step 2] Running YaHS for scaffolding..."
${YAHS} --no-contig-ec --no-scaffold-ec ${REFERENCE_GENOME} ${BED_FILE}
/opt/software/mambaforge/envs/yahs/bin/yahs --no-contig-ec --no-scaffold-ec 1154.fasta /data/work/hiC/1154/1154/hiC_result_Final/bowtie_results/bwt2/fastq/DP8480016520BR_L01_1_1154_polished_index.bwt2pairs.bam 

# 输出：yahs.out_scaffolds_final.agp / yahs.out.bin / yahs.out_scaffolds_final.fa
echo "[Info] YaHS scaffolding done."

# ========================== JUICER FOR VISUALIZATION ==========================
echo "[Step 3] Running juicer pre (-a) for Juicebox editing..."
${JUICER_PRE} pre -a -o out_${OUTPUT_PREFIX} \
    yahs.out.bin yahs.out_scaffolds_final.agp ${REFERENCE_GENOME}.fai > out_${OUTPUT_PREFIX}.log 2>&1
/opt/software/mambaforge/envs/yahs/bin/juicer pre -a -o out_1154_scaff yahs.out.bin yahs.out_scaffolds_final.agp 1154.fasta.fai > out_1154_scaff.log 2>&1

# ========================== ASSEMBLY LENGTHS ==========================
echo "[Step 4] Extracting assembly size from YaHS log..."
ASM_SIZE=$(grep "PRE_C_SIZE" out_${OUTPUT_PREFIX}.log | awk '{print $3}')
GENOME_ID="assembly ${ASM_SIZE}"
echo "${GENOME_ID}" > ${OUTPUT_PREFIX}.chrom.sizes
echo "[Info] Assembly size written to ${OUTPUT_PREFIX}.chrom.sizes"

# ========================== JUICER FOR VISUALIZATION ==========================
echo "[Step 5] Generating .hic file using juicer_tools..."
${JUICER_TOOLS} pre --threads 64 \
  out_${OUTPUT_PREFIX}.txt out_${OUTPUT_PREFIX}.hic.part ${OUTPUT_PREFIX}.chrom.sizes > out_tools.log 2>&1

mv out_${OUTPUT_PREFIX}.hic.part out_${OUTPUT_PREFIX}.hic

echo "[DONE] .hic file saved to out_${OUTPUT_PREFIX}.hic"
