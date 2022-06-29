process LILAC {
  //conda (params.enable_conda ? "bioconda::hmftools-lilac=1.2" : null)
  container 'docker.io/scwatts/lilac:1.2'

  input:
  tuple val(meta), path(tumor_bam), path(normal_bam), path(rna_bam), path(purple_dir)
  path(ref_data_genome_dir)
  val(ref_data_genome_fn)
  path(lilac_resource_dir)

  output:
  tuple val(meta), path('lilac/'), emit: lilac_dir
  path 'versions.yml'            , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  def sample_name = get_sample_name(meta, tumor_bam, normal_bam)
  def tumor_bam_arg = tumor_bam ?: "-tumor_bam ${tumor_bam}"
  def reference_bam_arg = normal_bam ?: "-reference_bam ${reference_bam}"
  def rna_bam_arg = rna_bam ?: "-rna_bam ${rna_bam_arg}"
  def purple_args = purple_dir ?: """
    -gene_copy_number_file ${purple_dir}/${sample_name}.purple.cnv.gene.tsv \
    -somatic_variants_file ${purple_dir}/${sample_name}.purple.sv.vcf.gz \
  """
  """
  java \
    -Xmx${task.memory.giga}g \
    -jar "${task.ext.jarPath}" \
    -sample "${sample_name}" \
    ${tumor_bam_arg} \
    ${reference_bam_arg} \
    -ref_genome_version 38 \
    -ref_genome "${ref_data_genome_dir}/${ref_data_genome_fn}" \
    -resource_dir "${lilac_resource_dir}" \
    ${purple_args} \
    -threads "${task.cpus}" \
    -output_dir lilac/

  # NOTE(SW): hard coded since there is no reliable way to obtain version information.
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      lilac: 1.2
  END_VERSIONS
  """

  stub:
  """
  mkdir -p lilac/
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}

def get_sample_name(meta, tumor_bam, normal_bam) {
    if (tumor_bam) {
        return meta.get(['sample_name', 'tumor'])
    } else if (normal_bam) {
        return meta.get(['sample_name', 'normal'])
    } else {
        Sys.exit(1)
    }
}

