process PREPROCESS {
  //conda (params.enable_conda ? "bioconda::gridss=2.13.2" : null)
  container 'docker.io/scwatts/gridss:2.13.2'

  input:
  tuple val(meta), val(sample_name), path(bam)
  path(ref_data_genome_dir)
  val(ref_data_genome_fn)

  output:
  tuple val(meta), val(sample_name), path("gridss_preprocess/${bam.name}.gridss.working/"), emit: preprocess_dir
  path 'versions.yml'                                                                     , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  """
  gridss \
    --jvmheap "${task.memory.giga}g" \
    --jar "${task.ext.jarPath}" \
    --steps preprocess \
    --reference "${ref_data_genome_dir}/${ref_data_genome_fn}" \
    --workingdir gridss_preprocess/ \
    --threads "${task.cpus}" \
    "${bam}"

  # NOTE(SW): hard coded since there is no reliable way to obtain version information, see GH issue
  # https://github.com/PapenfussLab/gridss/issues/586
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      gridss: 2.13.2
  END_VERSIONS
  """

  stub:
  """
  mkdir -p gridss_preprocess/${bam.name}.gridss.working/
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}
