#/bin/bash

#####################################################################################
#   Description of the document

"""
    The example data includes sequencing data for intervals in the mouse genome from GSM753569. It is primarily used as a reference for AIMER usage.

    1. test_sorted.bam: The file where the methylation sequencing data is aligned to the reference genome and sorted.
    2. test_genome.fa: The reference genome.
    3. test_genome.gtf: The reference genome annotation file (Gene transfer format, GTF).
    4. test_known_dmr.bed: Known dmr bed file, which contain chr, start, end and name four columns, the first line need start with \"#\" if the bed file contain header line.
    5. test_tissue_annotation.txt: Your own file for possible tissue-specific AMR annotation; if you provide your own files, please note that the files contain Tissue and Gene columns, if there are more than one gene in the gene column, please separate them with comma.
    6. test.AIMER.bin.bed: Output file of AIMER get_bin step. AIMER uses a sliding window to separate the bam into a single region (bin), and the output file contains the following columns: 
        #chr: Chromosome name.
        start: Start coordinate on the chromosome for the sequence considered.
        end: End coordinate on the chromosome or scaffold for the sequence considered.
        m1: The average methylation levels of sequences from group 1.
        m2: The average methylation levels of sequences from group 2.
        m1_read: The number of sequences originating from group 1.
        m2_read: The number of sequences originating from group 2.
        alpha1: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups.
        ave_methylation_level: The average methylation level of the region separated by the sliding window.
        diff: The difference between the average methylation levels of the sequences in the two groups.
        cytosine_count_in_CG: The number of CGs in a single bin.
        alpha: The probability of a read originating from group 1 in a single region.
    7. test.AIMER.extended.bed: Output file of AIMER bin_extension step. AIMER extends the adjacent bins from the output of get_bin and merges them into a longer region, and the region contains the following columns:
        #Chr: Chromosome name.
        Start: Start coordinate on the chromosome for the sequence considered.
        End: End coordinate on the chromosome or scaffold for the sequence considered.
        Score: The difference between the average methylation levels of the sequences in the two groups.
        Length: Length of the area resulting from the bin_extension step.
        Max_cg: Each bin has a specific CG count, and Max_CG represents the CG count of the bin with the highest CG content in a merged region.
        Ratio: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups in a merged region.

    8. test.AIMER.AMR.anno.bed: Output file of AIMER get_amr step. Basically, AIMER calculates the similarity score between the obtained region and the known imprinted DMR from the output of bin_extension. If a GTF annotation file is provided, the program will annotate the AMR to the corresponding genes, and if the bed file of the known imprinted DMR is provided, the software will also annotate whether the AMR is overlapping with the known AMR. If a list of tissue-specific genes is provided, the program will mark the corresponding tissue in the AMR. The output file contains the following columns:
        #Chr: Chromosome name.
        Start: Start coordinate on the chromosome for the sequence considered.
        End: End coordinate on the chromosome or scaffold for the sequence considered.
        Score: The difference between the average methylation levels of the sequences in the two groups.
        Length: Length of the area resulting from the bin_extension step.
        Max_cg: Each bin has a specific CG count, and Max_CG represents the CG count of the bin with the highest CG content in a merged region.
        Ratio: The ratio of the count of the minor group in Group 1 and Group 2 divided by the total number of the two groups in a merged region.
        Prob: The similarity score between the obtained region and the known imprinted DMR.
        Gene: Genes corresponding to the AMR.
        Known: known imprinted DMR, which intersects with AMR.
        Tissue: The genes associated with AMR were found to have tissue-specific expression in these tissues.
    Note: Gene, Known and Tissue columns will be generated only if the corresponding parameters are provided.

"""


#####################################################################################
#   For example

################
#   1st step. get_bin step utilize a sliding window to split the chromosome into continuous bins, then the reads are divided into two groups by the EM algorithm in each bin.
AIMER get_bin -i test_sorted.bam -g test_genome.fa -o test.AIMER.bin.bed

################
#   2st step. bin_extension extends the adjacent bins from the output of get_bin and merges them into a longer region.
AIMER bin_extension -i test.AIMER.bin.bed -r 0.4 -d 0.9 -g 700 -c 10 -o test.AIMER.extended.bed

################
#   3st step. Basically, get_amr calculates the similarity score between the obtained region and the known imprinteded DMR from the output of bin_extension.
AIMER get_amr -i test.AIMER.extended.bed -o AMR.1

# or if you provide a GTF annotation file, the program will annotate the AMR to the corresponding genes
AIMER get_amr -i test.AIMER.extended.bed -o AMR.2 -g test_genome.gtf

# or if you provide the known imprinted DMR bed file, the program will annotate the AMR to the corresponding known imprinted DMRs.
AIMER get_amr -i test.AIMER.extended.bed -o AMR.3 -k test_known.bed
AIMER get_amr -i test.AIMER.extended.bed -o AMR.4 -g test_genome.gtf -k test_known.bed

# or if you specify a species (mouse or human), or provide a tissue-specific expression file, in the --annotation parameter, the program will mark the corresponding tissue in the AMR.
AIMER get_amr -i test.AIMER.extended.bed -o AMR.5 -g test_genome.gtf -a mouse
AIMER get_amr -i test.AIMER.extended.bed -o AMR.6 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt
AIMER get_amr -i test.AIMER.extended.bed -o AMR.7 -g test_genome.gtf -k test_known.bed -a test_tissue-specific_expression_genes.txt

# or if you provide the tissue type of the sample, the program will remove the AMR, which is annotated to the corresponding tissue. The tissue type refers to the README file if you use the specified human or mouse in the --annotation instead of your own file. If you use your own file, you need to specify it according to the tissue type in the file.
AIMER get_amr -i test.AIMER.extended.bed -o AMR.8 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt -e "Colon"
AIMER get_amr -i test.AIMER.extended.bed -o AMR.9 -g test_genome.gtf -a test_tissue-specific_expression_genes.txt -k test_known.bed -e "Colon"
