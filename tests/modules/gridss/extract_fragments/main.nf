#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { EXTRACT_FRAGMENTS } from '../../../../modules/gridss/extract_fragments/main.nf'

workflow test_extract_fragments {
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
    file(
      './nextflow_testdata/hmftools/structural_variants/SEQC-II-50pc-manta.vcf.gz',
      checkIfExists: true
    ),
  ]

  // Run module
  EXTRACT_FRAGMENTS(
    ch_input,
  )
}
