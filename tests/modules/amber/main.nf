#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { AMBER } from '../../../modules/amber/main.nf'

workflow test_amber {
  // Set up inputs
  ch_input = [
    [
      ['sample_name', 'tumor']: 'TEST_sample_tumor',
      ['sample_name', 'normal']: 'TEST_sample_normal',
    ],
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Tumor_50pc-ready.bam',
      checkIfExists: true
    ),
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Normal-ready.bam',
      checkIfExists: true
    ),
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Tumor_50pc-ready.bam.bai',
      checkIfExists: true
    ),
    file(
      './nextflow_testdata/hmftools/read_sets/SEQC-II_Normal-ready.bam.bai',
      checkIfExists: true
    ),
  ]
  amber_loci = file('./reference_data/hmftools/amber/GermlineHetPon.38.vcf.gz', checkIfExists: true)

  // Run module
  AMBER(
    ch_input,
    amber_loci,
  )
}
