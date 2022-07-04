process LINX_GERMLINE {
  //conda (params.enable_conda ? "bioconda::hmftools-linx=1.19" : null)
  container 'quay.io/biocontainers/hmftools-linx:1.19--hdfd78af_0'

  input:
  tuple val(meta), path(gripss_sv)
  path fragile_sites
  path line_elements
  path ensembl_data_dir
  path driver_gene_panel

  output:
  tuple val(meta), path('linx_germline/'), emit: annotation_dir
  path 'versions.yml'                    , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  def args = task.ext.args ?: ''

  """
  java \
    -Xmx${task.memory.giga}g \
    -jar "${task.ext.jarPath}" \
      ${args} \
      -sample "${meta.get(['sample_name', 'normal'])}" \
      -germline \
      -ref_genome_version 38 \
      -sv_vcf "${gripss_sv}" \
      -fragile_site_file "${fragile_sites}" \
      -line_element_file "${line_elements}" \
      -ensembl_data_dir "${ensembl_data_dir}" \
      -check_drivers \
      -driver_gene_panel "${driver_gene_panel}" \
      -output_dir linx_germline/

  # NOTE(SW): hard coded since there is no reliable way to obtain version information
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      linx: 1.19
  END_VERSIONS
  """

  stub:
  """
  mkdir linx_germline/
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}
