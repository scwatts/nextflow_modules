#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { LINX_REPORT } from '../../../../modules/gpgr/linx_report/main.nf'

workflow test_linx_report {
  // Set up inputs
  ch_input = [
    [
      ['sample_name', 'tumor']: 'SEQC-II_Tumor_50pc',
      ['sample_name', 'normal']: 'TEST_sample_normal',
    ],
    file(
      './nextflow_testdata/hmftools/linx_annotation/',
      checkIfExists: true
    ),
    file(
      './nextflow_testdata/hmftools/linx_visualiser/plot',
      checkIfExists: true
    ),
  ]

  // Run module
  LINX_REPORT(
    ch_input,
  )
}
