process ANNOTATION {
  conda (params.enable_conda ? "bioconda::hmftools-linx=1.19" : null)
  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    'https://depot.galaxyproject.org/singularity/hmftools-linx:1.19--hdfd78af_0' :
    'quay.io/biocontainers/hmftools-linx:1.19--hdfd78af_0' }"

  input:
  tuple val(meta), path(purple)
  path(fragile_sites)
  path(line_elements)
  path(ensembl_data_dir)
  path(known_fusion_data)
  path(driver_gene_panel)

  output:
  tuple val(meta), path('linx_annotation/'), emit: annotation_dir
  path 'versions.yml'                      , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  """
  java \
    -Xmx${task.memory.giga}g \
    -jar "${task.ext.jarPath}" \
      -sample "${meta.get(['sample_name', 'tumor'])}" \
      -ref_genome_version 38 \
      -sv_vcf "${purple}/${meta.get(['sample_name', 'tumor'])}.purple.sv.vcf.gz" \
      -purple_dir "${purple}" \
      -output_dir linx_annotation/ \
      -fragile_site_file "${fragile_sites}" \
      -line_element_file "${line_elements}" \
      -ensembl_data_dir "${ensembl_data_dir}" \
      -check_fusions \
      -known_fusion_file "${known_fusion_data}" \
      -check_drivers \
      -driver_gene_panel "${driver_gene_panel}"

  # NOTE(SW): hard coded since there is no reliable way to obtain version information
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      linx: 1.19
  END_VERSIONS
  """

  stub:
  """
  mkdir linx_annotation/
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}