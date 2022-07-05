#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { SAGE_SOMATIC } from '../../../../modules/sage/somatic/main.nf'

workflow test_sage_somatic {
  // Set up inputs
  ch_input = [
    [
      'subject_name': 'SEQC-II',
      ['sample_name', 'tumor']: 'SEQC-II_Tumor_50pc',
      ['sample_name', 'normal']: 'SEQC-II_Normal',
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
  genome_dir = file('./reference_data/genomes/', checkIfExists: true)
  genome_fn = 'hg38.fa'
  sage_known_hotspots_somatic = file('./reference_data/hmftools/sage/KnownHotspots.somatic.38.vcf.gz', checkIfExists: true)
  sage_coding_panel_somatic = file('./reference_data/hmftools/sage/ActionableCodingPanel.somatic.38.bed.gz', checkIfExists: true)
  sage_high_confidence = file('./reference_data/hmftools/sage/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed.gz', checkIfExists: true)
  ensembl_data_dir = file('./reference_data/hmftools/ensembl_data_cache/', checkIfExists: true)

  // Run module
  SAGE_SOMATIC(
    ch_input,
    genome_dir,
    genome_fn,
    sage_known_hotspots_somatic,
    sage_coding_panel_somatic,
    sage_high_confidence,
    ensembl_data_dir,
  )
}
