#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { PAVE_SOMATIC } from '../../../../modules/pave/somatic/main.nf'

workflow test_pave_somatic {
  // Set up inputs
  ch_input = [
    [
      ['sample_name', 'tumor']: 'SEQC-II_Tumor_50pc',
    ],
    file(
      './nextflow_testdata/hmftools/sage/SEQC-II.sage_somatic.vcf.gz',
      checkIfExists: true
    ),
  ]
  genome_dir = file('./reference_data/genomes/', checkIfExists: true)
  genome_fn = 'hg38.fa'
  ensembl_data_dir = file('./reference_data/hmftools/ensembl_data_cache/', checkIfExists: true)
  driver_gene_panel = file('./reference_data/hmftools/gene_panel/DriverGenePanel.38.tsv', checkIfExists: true)
  mappability_bed = file('./reference_data/hmftools/mappability/mappability_150.38.bed.gz', checkIfExists: true)
  sage_pon_file = file('./reference_data/hmftools/sage/SageGermlinePon.98x.38.vcf.gz', checkIfExists: true)

  // Run module
  PAVE_SOMATIC(
    ch_input,
    genome_dir,
    genome_fn,
    sage_pon_file,
    mappability_bed,
    driver_gene_panel,
    ensembl_data_dir,
  )
}
