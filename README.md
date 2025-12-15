# PublicPipeline_GenomeAssembly
A guide on genome assembly study. The whole pipeline contains assembly - polishing - scaffolding - repeat annotation - genome annotation

## 1. Genome Assembly - [NextDeNovo (version 2.5.2)](https://github.com/Nextomics/NextDenovo)

Input your files and parameters, then run the software with this command

`NextDenovo nextdenovo_config.txt`

More details on https://github.com/keen-laras/CycloneSEQ_NextDeNovo_GenomeAssembly

## 2. Genome Polish - [NextPolish (version 1.4.1)](https://github.com/Nextomics/NextDenovo) 

Input your files and parameters, then run the software with this command

`nextPolish nextpolish_config.txt`

More details on https://github.com/keen-laras/CycloneSEQ_NextPolish_GenomePolish

## 3. Scaffolding - [YaHS](https://github.com/c-zhou/yahs), [Juicer](https://github.com/aidenlab/juicer) & [Juicer_tools](https://github.com/aidenlab/JuicerTools)

Run alignments using,

`bash run_bowtie2.sh` then `run scaffolding_script1.sh`

or

`bash run_chromap.sh` then `run scaffolding_script2.sh`

More details on https://github.com/keen-laras/GenomeScaffolding

## 4. Repeat Annotation - [RepeatMasker (version 4.2.2)](https://github.com/Dfam-consortium/RepeatMasker) 

- Run software depending on your library

`bash run_denovo.sh` or `bash run_lib.sh`

- Mask output file
  1. `perl extract_lowercase_bed.pl /path/to/repeatmasker/{sample}.fa.masked {output}.nmasked.bed`
  2. `cat /denovo/{output}.nmasked.bed /dfam_lib/{output}.nmasked.bed > {output}_combined_nmasked.raw.bed sort -k1,1 -k2,2n {output}_combined_nmasked.raw.bed > {output}_combined_nmasked.sorted.bed`
  3. `/bedtools/2.29.2/bin/mergeBed -i {output}_combined_nmasked.sorted.bed > {output}_combined_nmasked.merged.bed`
  4. `/bedtools/2.29.2/bin/maskFastaFromBed -mc N -fi /path/to/{sample}.fa -fo {output}.FINAL.masked.fa -bed {output}_combined_nmasked.merged.bed`

More details on https://github.com/keen-laras/RepeatAnnotation/tree/main

## 5. Genome Annotation - [EviAnn (version 2.0.4)](https://github.com/alekseyzimin/EviAnn_release) & [BRAKER (version 3.0.8)](https://github.com/Gaius-Augustus/BRAKER)

- Run both software

`bash run_eviann.sh` and `bash run_braker.sh`

- Merge both pipeline's output

`bash run_mergeOutput.sh`

More details on https://github.com/keen-laras/GenomeAnnotation
