#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { CALL } from '../../../../modules/gridss/call/main.nf'

workflow test_call {
  // Set up inputs
  ch_input = [
    [:],
    [
      file(
        './nextflow_testdata/hmftools/gridss_extract_fragments/SEQC-II_Tumor_50pc-ready.targeted.bam',
        checkIfExists: true
      ),
      file(
        './nextflow_testdata/hmftools/read_sets/SEQC-II_Normal-ready.bam',
        checkIfExists: true
      ),
    ],
    [
      file(
        './nextflow_testdata/hmftools/gridss_assemble/',
        checkIfExists: true
      ),
    ],
    ['SEQC-II_Tumor_50pc', 'SEQC-II_Normal'],
  ]
  gridss_config = file('./nextflow_testdata/hmftools/misc/gridss_config.txt', checkIfExists: true)
  genome_dir = file('./reference_data/genomes/', checkIfExists: true)
  genome_fn = 'hg38.fa'
  gridss_blacklist = file('./reference_data/hmftools/gridss/ENCFF356LFX.bed', checkIfExists: true)

  // Run module
  CALL(
    ch_input,
    gridss_config,
    genome_dir,
    genome_fn,
    gridss_blacklist,
  )
}
