#   1st step, get_bin
AIMER get_bin -i test_sorted.bam -g test_genome.fa -o bin.bed

#   2st step, get_bin
AIMER bin_extension -i bin.bed -r 0.4 -d 0.9 -g 700 -c 10 -o extended.bed

#   3st step, get_amr
AIMER get_amr -i extended.bed -o AMR.1
AIMER get_amr -i extended.bed -o AMR.2 -g test_genome.gtf
AIMER get_amr -i extended.bed -o AMR.3 -g test_genome.gtf -k test_known.bed
AIMER get_amr -i extended.bed -o AMR.4 -g test_genome.gtf -e test_exclud.txt
AIMER get_amr -i extended.bed -o AMR.5 -g test_genome.gtf -k test_known.bed -e test_exclud.txt
