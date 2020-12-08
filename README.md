### Assembling Illumina sequences

The following pipeline was used to assembly Illumina sequences of whole genomic DNA of the species *Holochilus sciureus* (2n = 56, NF = 56), a Neotropical rodent of Oryzomyini tribe.

- Softwares used:

meraculous-v2.2.6_miniconda-v4.8.1 | https://sourceforge.net/projects/meraculous20/ | Chapman JA, Ho I, Sunkara S, Luo S, Schroth G P, Rokhsar DS (2011). Meraculous: De novo genome assembly with short paired-end reads. PLoS ONE, 6(8):e23501.

SPAdes-3.14.0-Linux | https://cab.spbu.ru/software/spades/ | Nurk S, Bankevich A, Antipov D, Gurevich AA, Korobeynikov A, Lapidus A, Prjibelski AD, Pyshkin A, Sirotkin A, Sirotkin Y, Stepanauskas R, Clingenpeel SR, Woyke T, Mclean JS, Lasken R, Tesler G, Alekseyev MA, Pevzner PA (2013) Assembling single-cell genomes and mini-metagenomes from chimeric MDA products. J Comput Biol, 20(10):714–737.

BBMap_38.49 | https://jgi.doe.gov/data-andtools/bbtools/bb-tools-user-guide/bbduk-guide/ | Bushnell B, Rood J, Singer E (2017) BBMerge–accurate paired shotgun read merging via overlap. PloS one, 12(10),e0185056.

quast-5.0.2 | http://quast.sourceforge.net/ | Gurevich A, Saveliev V, Vyahhi N, Tesler G (2013) QUAST: quality assessment tool for genome assemblies. Bioinformatics, 29(8):1072–1075.

### Step 1 > Assembly with meraculous:

Meraculous is a easy going algorithm for whole genome assembly of short paired-end reads. The first step of this process was to assembly the whole genome using filtered reads https://github.com/MoreiraCN/Filtering_Illumina_sequence. Meraculous script is avalible at https://github.com/MoreiraCN/Assembling_Illumina_sequences/blob/main/script_assembly_meraculous.

- Command line used:

run_meraculous.sh -c script_assembly_meraculous

**Input data:**

- wildcard: path to filtered libraries.
- prefix: name of the library.
- insAvg: estimated average insert size in bp.
- insSdev: estimated std deviation of insert size in bp.
- avgReadLen: estimated average read length in bp.
- hasInnieArtifact: whether or not a significant fraction of read pairs is in nondominant orientation, e.g. "innies" in an "outie" library or vice versa (0 = false, 1 = true).
- isRevComped: whether or not the read pairs are in the "outie" orientation (0 = false, 1 = true).
- useForContigging: whether or not to use this libray for initial contig generation (0 = false, 1 = true).
- useForGapClosing: whether or not to use this library for gap closing (0 = false, 1 = true).
- 5pWiggleRoom: during linkage analysis and gap closure, allow reads from this library to have an unaligned 5' end up to this many bp (positive integer, 0 for default behavior).
- 3pWiggleRoom: during linkage analysis and gap closure, allow reads from this library to have an unaligned 3' end up to this many bp (positive integer, 0 for default behavior).

**Parameters used:**

- genome_size: approximate genome size in Gb.
- mer_size: *K*-mer size to use in meraculous. For this assembly was tested all *K*-mer values from 21 to 135.
- diploid_mode: specifies whether to attempt to identify and merge haplotype variants (0 = false, 1 = true).
- num_prefix_blocks: memory usage.
- min_depth_cutoff: *K*-mers less frequent than this cutoff will get excluded from assembly early on.
- no_read_validation: set to 1 to skip validation of input fastq reads' headers, sequence, and q-scores (0 = false, 1 = true).
- use_cluster: specifies whether to use a cluster for job submissions.
- local_num_procs: valid only when *use_cluster* is off. Max of 50.
- local_max_retries: number of retries before failure for local jobs.

For more details see: http://1ofdmq2n8tc36m6i46scovo2e.wpengine.netdna-cdn.com/wp-content/uploads/2014/12/Manual.pdf

**Remarks:**

The values of **insAvg, insSdev and avgReadLen** can be determined using a bbmap package, by the Command line:

bbmap/bbmerge-auto.sh in1=out_r1_filtered_paired.fq.gz in2=out_r2_filtered_paired.fq.gz ihist=out_filtered_paired_insertsize.txt prefilter=2 rem extend2=100 k=62

For more details see: https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbmerge-guide/

The best assembly can be evaluated using the software QUAST, by the Command line: 

python quast-5.0.2/quast.py -o output_file -r reference_genome.fa -t numer_of_CPUs assembly_01_k21.fa assembly_02_k23.fa ... assembly_58_k135.fa reference_genome.fa

### Step 2 > Reassembly with SPAdes:

SPAdes is a assembly toolkit that contains various assembly pipelines. In this second step the best assembly, evaluated by QUAST analisys, will be reassembled with SPAdes. SPAdes script is avalible at (incluir link_script_reassembly_SPAdes).

- Command line used: sh script_reassembly_SPAdes

**Input data:**

- pe11: path to filtered libraries.
- longreads: path to meraculous assembly.

**Parameters used:**

- spades_loc: path to SPAdes.
- kmers: K-mers values to assembly.
- processors: number of processors.
- output_folder: output directory.

For more details see: https://cab.spbu.ru/files/release3.12.0/manual.html

**Remarks:**

The best assembly can be evaluated using the software QUAST, by the Command line: 

python quast-5.0.2/quast.py -o output_file -r reference_genome.fa -t numer_of_CPUs reassembly_01_k57.fa reassembly_02_k59.fa ... assembly_36_k137.fa reference_genome.fa
