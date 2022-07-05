#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { SAGE_GERMLINE } from '../../../../modules/sage/germline/main.nf'

workflow test_sage_germline {
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
  sage_known_hotspots_germline = file('./reference_data/hmftools/sage/KnownHotspots.germline.38.vcf.gz', checkIfExists: true)
  sage_coding_panel_germline = file('./reference_data/hmftools/sage/ActionableCodingPanel.germline.38.bed.gz', checkIfExists: true)
  sage_high_confidence = file('./reference_data/hmftools/sage/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed.gz', checkIfExists: true)
  ensembl_data_dir = file('./reference_data/hmftools/ensembl_data_cache/', checkIfExists: true)

  // Run module
  SAGE_GERMLINE(
    ch_input,
    genome_dir,
    genome_fn,
    sage_known_hotspots_germline,
    sage_coding_panel_germline,
    sage_high_confidence,
    ensembl_data_dir,
  )
}
