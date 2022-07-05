#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { ASSEMBLE } from '../../../../modules/gridss/assemble/main.nf'

workflow test_assemble {
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
        './nextflow_testdata/hmftools/gridss_preprocess/SEQC-II_Tumor_50pc-ready.targeted.bam.gridss.working',
        checkIfExists: true
      ),
      file(
        './nextflow_testdata/hmftools/gridss_preprocess/SEQC-II_Normal-ready.bam.gridss.working',
        checkIfExists: true
      ),
    ],
    ['TEST_sample_tumor', 'TEST_sample_normal'],
  ]
  gridss_config = file('./nextflow_testdata/hmftools/misc/gridss_config.txt', checkIfExists: true)
  genome_dir = file('./reference_data/genomes/', checkIfExists: true)
  genome_fn = 'hg38.fa'
  gridss_blacklist = file('./reference_data/hmftools/gridss/ENCFF356LFX.bed', checkIfExists: true)

  // Run module
  ASSEMBLE(
    ch_input,
    gridss_config,
    genome_dir,
    genome_fn,
    gridss_blacklist,
  )
}
