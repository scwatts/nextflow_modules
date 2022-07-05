#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { PREPROCESS } from '../../../../modules/gridss/preprocess/main.nf'

workflow test_preprocess {
  // Set up inputs
  ch_input = [
    [:],
    file(
      './nextflow_testdata/hmftools/gridss_extract_fragments/SEQC-II_Tumor_50pc-ready.targeted.bam',
      checkIfExists: true
    ),
  ]
  gridss_config = file('./nextflow_testdata/hmftools/misc/gridss_config.txt', checkIfExists: true)
  genome_dir = file('./reference_data/genomes/', checkIfExists: true)
  genome_fn = 'hg38.fa'

  // Run module
  PREPROCESS(
    ch_input,
    gridss_config,
    genome_dir,
    genome_fn,
  )
}
