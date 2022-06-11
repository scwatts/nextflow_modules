process EXTRACT_FRAGMENTS {
  conda (params.enable_conda ? "bioconda::gridss=2.13.2" : null)
  container 'docker.io/scwatts/gridss:2.13.2'

  input:
  tuple val(meta), val(sample_name), path(bam), path(bai), path(manta_vcf)

  output:
  tuple val(meta), val(sample_name), path("${output_fp}"), emit: bam
  path 'versions.yml'                                    , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  output_fp = "gridss_extract_fragments/${bam.getSimpleName()}.targeted.bam"
  """
  # Run
  gridss_extract_overlapping_fragments \
    --jar "${task.ext.jarPath}" \
    --targetvcf "${manta_vcf}" \
    --workingdir gridss_extract_fragments/work/ \
    --output "${output_fp}" \
    --threads "${task.cpus}" \
    "${bam}"
  # This script can exit silently, check that we have some reads in the output file before proceeding
  if [[ "\$(samtools view "${output_fp}" | head | wc -l)" -eq 0 ]]; then
    exit 1;
  fi;

  # NOTE(SW): hard coded since there is no reliable way to obtain version information, see GH issue
  # https://github.com/PapenfussLab/gridss/issues/586
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      gridss: 2.13.2
  END_VERSIONS
  """

  stub:
  output_fp = "gridss_extract_fragments/${bam.getSimpleName()}.targeted.bam"
  """
  mkdir -p gridss_extract_fragments/
  touch "${output_fp}"
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}
