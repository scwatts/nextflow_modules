#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { ANNOTATE } from '../../../../modules/gridss/annotate/main.nf'

workflow test_annotate {
  // Set up inputs
  ch_input = [
    [:],
    file(
      './nextflow_testdata/hmftools/gridss_call/sv_vcf.vcf.gz',
      checkIfExists: true
    ),
  ]

  // Run module
  ANNOTATE(
    ch_input,
  )
}
