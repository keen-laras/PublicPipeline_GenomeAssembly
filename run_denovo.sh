# ONLY RUN BUILDDATABASE ON DE NOVO ASSEMBLY TO CREATE A DE NOVO DATABASE

sample=sample_name
source ~/.bashrc
cd /workdir/
source /home/stereonote/miniconda3/bin/activate RepeatModeler
#make index database
BuildDatabase -name $sample /path/to/{input}.fa
#run RepeatModeler to make denovo predict library (-pa 30)==(-treads 120)
RepeatModeler -threads 64 -database $sample  &> repeatmodeler.log
mkdir repeatmodeler
mv $sample-families.fa repeatmodeler.log $sample-families.stk $sample-rmod.log repeatmodeler/ 

conda deactivate
source ~/.bashrc
source activate RepeatMasker
cd /workdir/
run RepeatMasker
RepeatMasker -xsmall -gff -a -lib repeatmodeler/$sample-families.fa -pa 64 -dir  repeatmasker/ /path/to/{input}.fa
