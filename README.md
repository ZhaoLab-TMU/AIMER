# AIMER
Genomic imprinting is a vital phenomenon during mammalian growth and development, which refers to genes that are preferentially expressed from either paternal or maternal allele. In mammals, such imprinting gene expression was identified to be regulated by allele-specific methylation (ASM) in some cis-acting regulatory regions in almost all of the known cases.Aberrant DNA methylation of allelic methylated regions (AMRs) is associated with certain diseases. By using sample-specific whole genome bisulfite sequencing (WGBS) methylome and its associating heterozygous SNP information, sample-specific AMRs could be detected. 

However, the AIMER is a SNP-independent computational software package for identifying imprinting-like allele-specific methylated regions (imprinting-like AMRs) from bisulfite sequencing data (WGBS). AIMER supports alignment BAM/SAM files as input files and is not SNP dependent for figuring out AMR and calculating the likelihood that the region is comparable to the imprinting AMR in a single sample. AIMER contains three sub-commands, get_bin, bin_extension and get_amr.  

Release AIMER 0.1

# Install AIMER 0.1  
pip3 install AIMER-0.1.tar.gz  
  
# Required libraries  
numpy-1.22.3  
gtfparse-1.2.1  
pandas-1.4.2  
pyfasta-0.5.2  
pybedtools>=0.9.0  
pyranges>=0.0.115  
gtfparse>=1.2.1  
  
  
Usage  
==========================  
Main program contains 3 sub-command, get_bin, bin_extension and get_amr, if you want to find out how to use each sub-command please use AIMER <sub-command> --help, such as AIMER get_bin --help.  
  
Usage:  
```
    AIMER COMMAND [ARGS...]  
    AIMER help COMMAND  
```
  
Options:  
  -h, --help  Show this help message and exit.  

Commands:  
  ***get_bin***             
  Using a sliding window to slice the genome into bins      
  ***bin_extension***       
  Merging bins from the output file of get_bin step      
  ***get_amr***             
  Used to calculate the probability of imprinting-like AMR and add annotations, users can also exclude unwanted results, such as tissue-specific genes        
  ***help (?)***  Give detailed help on a specific sub-command  

 
## Step 1  get_bin 
The *get_bin* step utilize a sliding window to split the chromosome into continuous bins, then the reads are divided into two groups by the EM algorithm in each bin. The output file of this step contains information such as the diff_score in methylation levels between the two groups.  
  
### Usage:  
    Usage: AIMER get_bin <-i filename> <-g ref_genome> <-b 300> <-c 10> <-o output>  
For example:   
  
        AIMER get_bin -i input.bam -b 300 -c 10 -g mm9.fa -o bin.bed  
  
Using sliding window to slice the genome into bins in this step  
  
Options:  
--version    Show program's version number and exit.  
    
-h, --help    Show this help message and exit.  
    
-i FILENAME, --input=FILENAME  

Coordinate sorted input file name, accept bam or sam format.  
                          
-b BINLENGTH, --bin=BINLENGTH  

Length of each bin, default is 300.  
                          
-s SAMTOOLS_PATH, --samtools_path=SAMTOOLS_PATH  

The path of samtools, if samtools is already in the  environment variable, it can be ignored.  
                          
-c COVERAGE_CUTOFF, --coverage=COVERAGE_CUTOFF  

Number of reads in each bin, default is 10 [n > 10]. 
                          
-g GENOME, --genome=GENOME  

The reference genenome.  
                          
-o OUTPUT, --output=OUTPUT  

Output bin file, default is bin.bed.  
                          

## Step 2  bin_extension 
The *bin_extension* step uses the output file from the *get_bin* to connect the short bin to the long contiguous region. Only reasonable and adjacent bins can be merged into a region.  
  
### Usage:  
    Usage: AIMER bin_extension <-i bin.bed> <-g GapLength> <-r Ratio> <-d Diff_Score> <-c CG> <-o extended.bed>  
For example:   
    
        AIMER bin_extension -i bin.bed -r 0.4 -d 0.8 -g 600 -c 10 -o extended.bed  
  
Merging bins from the output file of get_bin step  
  
Options:  
  --version             Show program's version number and exit. 
    
  -h, --help            Show this help message and exit.  
    
  -i INPUT_BIN, --input=INPUT_BIN
  
  The input bin bed file, it is the output of get_bin step.  
                          
  -r RATIO, --ratio=RATIO
  
  The proportion of minor part, min(m1,m2)/(m1+m2), default is 0.4 [n >= 0.4].  
                          
  -d DIFF_SCORE, --diff=DIFF_SCORE
  
  The diff score cutoff between the two part, default is 0.7 [n >= 0.7].  
                          
  -g GAP, --gap=GAP     
  
  The gap length to extend a merged AMR, default is 600 [n <= 600].  
                          
  -c CG, --cg=CG        
  
  The cg number of sigle bin, default is 10 [n >= 10].  
    
  -o OUTPUT, --output=OUTPUT
  
  The output of extended bin file, default is extended.bed.  
  

## Step 3  get_amr
The *get_amr* tool can be used to evaluate the probability of the regions generated by bin_extension be a imprint-like AMRs. If you know the Known_AMR list, you can also add known DMR annotation to the output bed file. In addition, if you want to exclude some genes from the results based on a given list, such as tissue spcific genes, you can use the --excluded_list parameter.  
  
### Usage:  
For example:  
    
        AIMER get_amr -i extended.bed  
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf  
        AIMER get_amr -i extended.bed -k known_dmr.bed  
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -e gene.list  
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -k known_dmr.bed  
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -k known_dmr.bed -e gene.list  
  
  
Used to calculate the probability of imprinting-like AMR and add
annotations  
  
Options:  
  --version             Show program's version number and exit.  
    
  -h, --help            Show this help message and exit.  
    
  -i FILENAME, --input=FILENAME      
  
  The output of extended region bed of bin_extension step.  
                          
  -t TSS, --tss=TSS    
  
  The size of TSS, default is +/- 3k.  
    
  -g GTF, --gtf=GTF    
  
  If you want to add TSS information or exclude any gene, please add this option.  
                          
  -e EXCLUDED_LIST, --excluded_list=EXCLUDED_LIST  
  
  Provide a gene list to enforce exclude that from the output files, each line is a single gene, only applies when used with -g option. 
                          
  -k KNOWN_DMR, --known_dmr=KNOWN_DMR  
  
  Known dmr bed file, which must contain chr, start, end and name four columns, the first line need start with "#" if the bed file contain header line.  
                          
  -o OUTPUT, --output=OUTPUT    
  
  Out put file name prefix, default output name is AMR.anno.bed.  
  

## Code example（with example data in *test* file）
Test shell script *test.sh*  
Test input file *test_sorted.bam*  
Test genome sequence file *test_genome.fa*   
Test genome annotation file *test_genome.gtf*  
Test known DMR bed file *test_known.bed*  
Test exclud gene list *extended.bed*  
####   1st step, get_bin
AIMER get_bin -i test_sorted.bam -g test_genome.fa -o bin.bed

####   2st step, get_bin
AIMER bin_extension -i bin.bed -r 0.4 -d 0.9 -g 700 -c 10 -o extended.bed

####   3st step, get_amr
AIMER get_amr -i extended.bed -o AMR.1  
AIMER get_amr -i extended.bed -o AMR.2 -g test_genome.gtf  
AIMER get_amr -i extended.bed -o AMR.3 -g test_genome.gtf -k test_known.bed  
AIMER get_amr -i extended.bed -o AMR.4 -g test_genome.gtf -e test_exclud.txt    
AIMER get_amr -i extended.bed -o AMR.5 -g test_genome.gtf -k test_known.bed -e test_exclud.txt  


Contacts and bug reports  
==========================  
  
ZhaoLab-TMU  
zhaolab_tmu@163.com  
  
Copyright and License Information  
==========================  
Copyright (C)   
  
Current Authors: ZhaoLab-TMU  
