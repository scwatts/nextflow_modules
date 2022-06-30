#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { ANNOTATE } from '../../../../modules/gridss/annotate/main.nf'

workflow test_annotate {
  // Set up inputs
  ch_input = [
    [
      ['sample_name', 'tumor']: 'TEST_sample_tumor',
      ['sample_name', 'normal']: 'TEST_sample_normal',
    ],
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
