process SAGE_SOMATIC {
  //conda (params.enable_conda ? "bioconda::hmftools-sage=3.0.3" : null)
  container 'quay.io/biocontainers/hmftools-sage:3.0.3--hdfd78af_0'

  input:
  tuple val(meta), path(tumor_bam), path(normal_bam)
  path(ref_data_genome_dir)
  val(ref_data_genome_fn)
  path(known_hotspots)
  path(sage_coding_panel)
  path(sage_high_confidence)
  path(ensembl_data_dir)

  output:
  tuple val(meta), path("${meta.subject_name}.sage.vcf.gz"), emit: vcf
  path 'versions.yml'                                      , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  """
  java \
    -Xmx${task.memory.giga}g \
    -jar "${task.ext.jarPath}" \
      -reference "${meta.get(['sample_name', 'normal'])}" \
      -reference_bam "${normal_bam}" \
      -tumor "${meta.get(['sample_name', 'tumor'])}" \
      -tumor_bam "${tumor_bam}" \
      -ref_genome_version 38 \
      -ref_genome "${ref_data_genome_dir}/${ref_data_genome_fn}" \
      -hotspots "${known_hotspots}" \
      -panel_bed "${sage_coding_panel}" \
      -high_confidence_bed "${sage_high_confidence}" \
      -ensembl_data_dir "${ensembl_data_dir}" \
      -threads "${task.cpus}" \
      -out "${meta.subject_name}.sage.vcf.gz"

  # NOTE(SW): hard coded since there is no reliable way to obtain version information.
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      sage: 3.0.3
  END_VERSIONS
  """

  stub:
  """
  touch "${meta.subject_name}.sage.vcf.gz"
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}