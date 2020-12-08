#path to filtered libraries
pe11='--pe1-1 /out_r1_filtered_paired.fq.gz --pe1-2 /out_r2_filtered_paired.fq.gz'; wait;
wait

#path to meraculous assembly
longreads="/assembly_xx_kxx.fa"
wait

#path to SPAdes
spades_loc="/SPAdes-3.14.0-Linux/bin/"

#K-mers values to assembly
kmers='57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127'; wait;
wait

#number of processors
processors="50"
wait

#output directory
output_folder="reassembly_SPAdes"
wait

#run
${spades_loc}spades.py -t ${processors} -k ${kmers} --careful --trusted-contigs ${longreads} ${pe11} -o ${output_folder}
wait
