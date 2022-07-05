#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { SAMBAMBA_SLICE } from '../../../../modules/sambamba/slice/main.nf'

workflow test_sambamba_slice {
  // Set up inputs
  ch_input = [
    [:],
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Tumor_50pc-ready.bam',
      checkIfExists: true
    ),
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Tumor_50pc-ready.bam.bai',
      checkIfExists: true
    ),
    [],
    ['chr10:87754038-87754038'],
  ]

  // Run module
  SAMBAMBA_SLICE(
    ch_input,
  )
}
