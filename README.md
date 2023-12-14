# Introduction
Genomic imprinting is a vital phenomenon during mammalian growth and development, which refers to genes that are preferentially expressed from either paternal or maternal allele. In mammals, such imprinting gene expression was identified to be regulated by allele-specific methylation (ASM) in some cis-acting regulatory regions in almost all of the known cases.Aberrant DNA methylation of allelic methylated regions (AMRs) is associated with certain diseases. By using sample-specific whole genome bisulfite sequencing (WGBS) methylome and its associating heterozygous SNP information, sample-specific AMRs could be detected.

However, the AIMER is a SNP-independent computational software package for identifying imprinting-like allele-specific methylated regions (imprinting-like AMRs) from bisulfite sequencing data (WGBS). AIMER supports alignment BAM/SAM files as input files and is not SNP dependent for figuring out AMR and calculating the likelihood that the region is comparable to the imprinting AMR in a single sample. AIMER contains three sub-commands, get_bin, bin_extension and get_amr.

The latest version is 0.1.1, and it is compatible with Python 3.9+. The Python source code for our project is now publicly available on both GitHub (https://github.com/ZhaoLab-TMU/AIMER) and Gitee (https://gitee.com/zhaolab_tmu/AIMER).

# Install AIMER
pip3 install AIMER-0.1.1.tar.gz

# Required libraries
numpy-1.22.3  
gtfparse-1.2.1  
pandas-1.4.2  
pyfasta-0.5.2  
pybedtools>=0.9.0  
pyranges>=0.0.115  
gtfparse>=1.2.1  

# Usage  
AIMER contains three sub-commands: get_bin, bin_extension and get_amr. You can also use AIMER --help to see the sub-commands included. Moreover, if you want to find out how to use each sub-command, please use AIMER <sub-command> --help command, for example: AIMER get_bin --help.

```shell
$ AIMER --help  

Usage:  
  AIMER COMMAND [ARGS...]  
  AIMER help COMMAND  

Options:  
  -h, --help  show this help message and exit  

Commands:  
  get_bin        Using a sliding window to slice the genome into bins.  
  bin_extension  Extending the adjacent bins from the output of get_bin and merges them into a longer region.  
  get_amr        Used to calculate the probability of imprinting-like AMR and add annotations, such as the corresponding gene(s), the known imprinted DMR, and the tissues where the corresponding gene(s) may be specifically expressed. Users can also optionally remove the corresponding AMR based on tissue-specific annotations.  
  help (?)       give detailed help on a specific sub-command.  
```

## Step 1 get_bin  
The get_bin step utilize a sliding window to split the chromosome into continuous bins, then the reads are divided into two groups by the EM algorithm in each bin. 

```shell
$ AIMER get_bin --help  
Usage:
    Usage: AIMER get_bin <-i filename> <-g ref_genome> <-b 300> <-c 10> <-o output>
    For example: AIMER get_bin -i input.bam -b 300 -c 10 -g mm9.fa -o bin.bed

        Using sliding window to slice the genome into bins in this step.

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -i FILENAME, --input=FILENAME
                        Coordinate sorted input file name, accept bam or sam
                        format.
  -b BINLENGTH, --bin=BINLENGTH
                        Length of each bin, default is 300
  -s SAMTOOLS_PATH, --samtools_path=SAMTOOLS_PATH
                        The path of samtools, if samtools is already in the
                        environment variable, it can be ignored.
  -c COVERAGE_CUTOFF, --coverage=COVERAGE_CUTOFF
                        Number of reads in each bin, default is 10 [n > 10].
  -g GENOME, --genome=GENOME
                        The reference genenome
  -o OUTPUT, --output=OUTPUT
                        Output bin file, default is bin.bed.
```

### Output format in get_bin
The output file of this step contains the information of the sequences from the two groups, the columns included in the output file refer to the description of the file [./examples/test.AIMER.bin.bed](6. test.AIMER.bin.bed)  


##  Step 2 bin_extension
The bin_extension step uses the output file from get_bin to merge the short bin into a longer contiguous region. Only reasonable and adjacent bins can be merged into a region.

```shell
$ AIMER bin_extension --help
Usage:
    Usage: AIMER bin_extension <-i bin.bed> <-g GapLength> <-r Ratio> <-d Diff_Score> <-c CG> <-o extended.bed>
    For example: AIMER bin_extension -i bin.bed -r 0.4 -d 0.8 -g 600 -c 10 -o extended.bed

        Extending the adjacent bins from the output of get_bin and merges them
into a longer region.

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -i INPUT_BIN, --input=INPUT_BIN
                        The input bin bed file, it is the output of get_bin
                        step.
  -r RATIO, --ratio=RATIO
                        The proportion of minor part, min(m1,m2)/(m1+m2),
                        default is 0.4 [n >= 0.4].
  -d DIFF_SCORE, --diff=DIFF_SCORE
                        The diff score cutoff between the two part, default is
                        0.7 [n >= 0.7].
  -g GAP, --gap=GAP     The gap length to extend a merged AMR, default is 600
                        [n <= 600].
  -c CG, --cg=CG        The cg number of sigle bin, default is 10 [n >= 10].
  -o OUTPUT, --output=OUTPUT
                        The output of extended bin file, default is
                        extended.bed.
```

### Output format in bin_extension 
The merged file is in bed format, the columns included in the output file refer to the description of the file ./examples/test.AIMER.extended.bed.  


##  Step 3 get_amr
Basically, the get_amr tool can be used to evaluate the probability of the regions generated by bin_extension be a imprint-like AMR. Optionally, if a GTF annotation file is provided, the program will annotate the AMR to the corresponding genes, and if the bed file of the known imprinted DMR is provided, the software will also annotate whether the AMR is overlapping with the known AMR. If a list of tissue-specific genes is provided, the program will mark the corresponding tissue in the AMR. Moreover, users can also optionally remove the corresponding AMR based on tissue-specific annotations.

```shell
$ AIMER get_amr --help
Usage:
    For example:
        AIMER get_amr -i extended.bed
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf
        AIMER get_amr -i extended.bed -k known_dmr.bed
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -a mouse
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -k known_dmr.bed -a mouse
        AIMER get_amr -i extended.bed -g mm9.refGene.gtf -k known_dmr.bed -a m8.all.v2023.1.Mm.symbols.xls -e "Colon"

        Used to calculate the probability of imprinting-like AMR and add annotations, such as the corresponding gene(s), the known imprinted DMR, and the tissues where the corresponding gene(s) may be specifically expressed. Users can also optionally remove the corresponding AMR based on tissue-specific annotations.

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -i FILENAME, --input=FILENAME
                        The output of extended region bed of bin_extension
                        step.
  -t TSS, --tss=TSS     The size of TSS, default is +/- 3k.
  -g GTF, --gtf=GTF     If you want to add TSS information or exclude any
                        gene, please add this option abd provide the GTF
                        annotation file.
  -a ANNOTATION, --annotation=ANNOTATION
                        Optional parameters. Human, mouse or your own file for
                        possible tissue-specific AMR annotation; if you give
                        "human" or "mouse", the program will automatically use
                        cell type signature gene sets from MSigDB for AMR
                        annotation; if you provide your own files, please note
                        that the files contain Tissue and Gene columns, if
                        there are more than one gene in the gene column,
                        please separate them with comma.Only applies when used
                        with the --gtf option.
  -e EXCLUDED_TISSUE, --excluded_tissue=EXCLUDED_TISSUE
                        Optional Parameter. Parameters are used to exclude
                        potential tissue-specific AMRs.If the specified tissue
                        of the sample is provided, the results will exclude
                        AMRs of the corresponding tissue according to the
                        annotation of the AMR. To determine the tissue types,
                        please refer to the README file if you are using
                        "human" or "mouse" in the --annotation parameter.
                        Parameter is only used if the --annotation is
                        provided.
  -k KNOWN_DMR, --known_dmr=KNOWN_DMR
                        Known dmr bed file, which must contain chr, start, end
                        and name four columns, the first line need start with
                        "#" if the bed file contain header line.
  -o OUTPUT, --output=OUTPUT
                        out put file name prefix, default output name is
                        AMR.anno.bed.
```

###  Note: 
1. If you use "human" or "mouse" in the --annotation parameter, the default tissue-specific expression gene table is obtained from the MSigDB cell type signature gene sets file. You can find the corresponding file in ./AIMER/resources/README.md.
2. The tissues included in human default annotation file are as follows:
    *  Adrenal, Bone Marrow, Cerebellum, Cerebrum, Cord Blood, Ctx, Duodenal, Esophageal, Esophagus, Eye, Gastric, Heart, Intestine, Kidney, Liver, Lung, Midbrain Neurotypes, Muscle, Olfactory Neuroepithelium, Ovary, Pancreas, Pfc, Placenta, Spleen, Thymus.
3. The tissues included in mouse default annotation file are as follows:
    *  Aorta, Bladder, Brain, Brown Adipose, Diaphragm, Gonadal Adipose, Heart, Heart And Aorta, Kidney, Large Intestine, Limb Muscle, Liver, Lung, Mammary Gland, Marrow, Mesenteric Adipose, Organogenesis, Pancreas, Skin, Spleen, Subcutaneous Adipose, Thymus, Tongue, Trachea, Trachea Smooth Muscle, Uterus.

### Output format in get_amr 
The columns included in the output file refer to the description of the file ./examples/test.AIMER.AMR.anno.bed.  


#  File description（see ./examples/）

The example data includes sequencing data for intervals in the mouse genome from GSM753569. It is primarily used as a reference for AIMER usage.

1. test_sorted.bam: The file where the methylation sequencing data is aligned to the reference genome and sorted.

2. test_genome.fa: The reference genome.

3. test_genome.gtf: The reference genome annotation file (Gene transfer format, GTF).

4. test_known_dmr.bed: Known dmr bed file, which contain chr, start, end and name four columns, the first line need start with \"#\" if the bed file contain header line.

5. test_tissue_annotation.txt: Your own file for possible tissue-specific AMR annotation; if you provide your own files please note that the files contain Tissue and Gene columns, if there are more than one gene in the gene column, please separate them with comma.

6. test.AIMER.bin.bed: Output file of AIMER get_bin step. AIMER uses a sliding window to separate the bam into a single region (bin), and the output file contains the following columns: 
    *  #chr: Chromosome name.
    *  start: Start coordinate on the chromosome for the sequence considered.
    *  end: End coordinate on the chromosome or scaffold for the sequence considered.
    *  m1: The average methylation levels of sequences from group 1.
    *  m2: The average methylation levels of sequences from group 2.
    *  m1_read: The number of sequences originating from group 1.
    *  m2_read: The number of sequences originating from group 2.
    *  alpha1: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups.
    *  ave_methylation_level: The average methylation level of the region separated by the sliding window.
    *  diff: The difference between the average methylation levels of the sequences in the two groups.
    *  cytosine_count_in_CG: The number of CGs in a single bin.
    *  alpha: The probability of a read originating from group 1 in a single region.

7. test.AIMER.extended.bed: Output file of AIMER bin_extension step. AIMER extends the adjacent bins from the output of get_bin and merges them into a longer region, and the region contains the following columns:
    *  #Chr: Chromosome name.
    *  Start: Start coordinate on the chromosome for the sequence considered.
    *  End: End coordinate on the chromosome or scaffold for the sequence considered.
    *  Score: The difference between the average methylation levels of the sequences in the two groups.
    *  Length: Length of the area resulting from the bin_extension step.
    *  Max_cg: Each bin has a specific CG count, and Max_CG represents the CG count of the bin with the highest CG content in a merged region.
    *  Ratio: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups in a merged region.

8. test.AIMER.AMR.anno.bed: Output file of AIMER get_amr step. Basically, AIMER calculates the similarity score between the obtained region and the known imprinted DMR from the output of bin_extension. If a GTF annotation file is provided, the program will annotate the AMR to the corresponding genes, and if the bed file of the known imprinted DMR is provided, the software will also annotate whether the AMR is overlapping with the known AMR. If a list of tissue-specific genes is provided, the program will mark the corresponding tissue in the AMR. The output file contains the following columns:
    *  #Chr: Chromosome name.
    *  Start: Start coordinate on the chromosome for the sequence considered.
    *  End: End coordinate on the chromosome or scaffold for the sequence considered.
    *  Score: The difference between the average methylation levels of the sequences in the two groups.
    *  Length: Length of the area resulting from the bin_extension step.
    *  Max_cg: Each bin has a specific CG count, and Max_CG represents the CG count of the bin with the highest CG content in a merged region.
    *  Ratio: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups in a merged region.
    *  Prob: The similarity score between the obtained region and the known imprinted DMR.
    *  Gene: Genes corresponding to the AMR.
    *  Known: known imprinted DMR, which intersects with AMR.
    *  Tissue: The genes associated with AMR were found to have tissue-specific expression in these tissues.

Note: Gene, Known and Tissue columns will be generated only if the corresponding parameters are provided.


#  Code example（see ./examples/test.sh）

###   1st step
get_bin step utilize a sliding window to split the chromosome into continuous bins, then the reads are divided into two groups by the EM algorithm in each bin.
```shell
AIMER get_bin -i test_sorted.bam -g test_genome.fa -o test.AIMER.bin.bed
```

###   2st step
bin_extension extends the adjacent bins from the output of get_bin and merges them into a longer region.
```shell
AIMER bin_extension -i test.AIMER.bin.bed -r 0.4 -d 0.9 -g 700 -c 10 -o test.AIMER.extended.bed
```

###   3st step
Basically, get_amr calculates the similarity score between the obtained region and the known imprinteded DMR from the output of bin_extension.
```shell
AIMER get_amr -i test.AIMER.extended.bed -o AMR.1
```
or if you provide a GTF annotation file, the program will annotate the AMR to the corresponding genes
```shell
AIMER get_amr -i test.AIMER.extended.bed -o AMR.2 -g test_genome.gtf
```
or if you provide the known imprinted DMR bed file, the program will annotate the AMR to the corresponding known imprinted DMRs.
```shell
AIMER get_amr -i test.AIMER.extended.bed -o AMR.3 -k test_known.bed
AIMER get_amr -i test.AIMER.extended.bed -o AMR.4 -g test_genome.gtf -k test_known.bed
```
or if you specify a species (mouse or human), or provide a tissue-specific expression file, in the --annotation parameter, the program will mark the corresponding tissue in the AMR.
```shell
AIMER get_amr -i test.AIMER.extended.bed -o AMR.5 -g test_genome.gtf -a mouse
AIMER get_amr -i test.AIMER.extended.bed -o AMR.6 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt
AIMER get_amr -i test.AIMER.extended.bed -o AMR.7 -g test_genome.gtf -k test_known.bed -a test_tissue-specific_expression_genes.txt
```
or if you provide the tissue type of the sample, the program will remove the AMR, which is annotated to the corresponding tissue. The tissue type refers to the README file if you use the specified human or mouse in the --annotation instead of your own file. If you use your own file, you need to specify it according to the tissue type in the file.
```shell
AIMER get_amr -i test.AIMER.extended.bed -o AMR.8 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt -e "Colon"
AIMER get_amr -i test.AIMER.extended.bed -o AMR.9 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt -k test_known.bed -e "Colon"
```

Contacts and bug reports
==========================
ZhaoLab-TMU
zhaolab_tmu@163.com

Copyright and License Information
==========================
Copyright (C) 

Current Authors: ZhaoLab-TMU
