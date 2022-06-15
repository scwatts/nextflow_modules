process ASSEMBLE {
  conda (params.enable_conda ? "bioconda::gridss=2.13.2" : null)
  container 'docker.io/scwatts/gridss:2.13.2'

  input:
  tuple val(meta), path(tumor_bam), path(normal_bam), val(tumor_preprocess), val(normal_preprocess)
  path(ref_data_genome_dir)
  val(ref_data_genome_fn)
  path(blacklist)

  output:
  tuple val(meta), path('gridss_assemble/'), emit: assembly_dir
  path 'versions.yml'                      , emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  output_dirname = 'gridss_assemble'

  """
  # Create shadow directory with file symlinks of GRIDSS 'working' dir to prevent cache invalidation
  # NOTE: for reasons that elude me, NF doesn't always stage in the workingdir; remove if it is present
  shadow_input_directory() {
    src=\${1}
    dst="${output_dirname}/work/\${src##*/}"
    for filepath_src in \$(find -L \${src} ! -type d); do
      # Get destination location for symlink
      filepath_src_rel=\$(sed 's#^'\${src}'/*##' <<< \${filepath_src})
      filepath_dst=\${dst%/}/\${filepath_src_rel}
      # Create directory for symlink
      mkdir -p \${filepath_dst%/*};
      # Get path for symlink source file, then create it
      # NOTE(SW): ideally we would get the relative path using the --relative-to but this is only
      # supported for GNU realpath and fails for others such as BusyBox, which is used in Biocontainers
      symlinkpath=\$(realpath \${filepath_src})
      ln -s \${symlinkpath} \${filepath_dst};
    done
    if [[ -L "\${src##*/}" ]]; then
      rm "\${src}"
    fi
  }
  shadow_input_directory ${tumor_preprocess}
  shadow_input_directory ${normal_preprocess}

  # Run
  gridss \
    --jvmheap "${task.memory.giga}g" \
    --jar "${task.ext.jarPath}" \
    --steps assemble \
    --labels "${meta.get(['sample_name', 'normal'])},${meta.get(['sample_name', 'tumor'])}" \
    --reference "${ref_data_genome_dir}/${ref_data_genome_fn}" \
    --blacklist "${blacklist}" \
    --workingdir "${output_dirname}/work" \
    --assembly "${output_dirname}/sv_assemblies.bam" \
    --threads "${task.cpus}" \
    "${normal_bam}" \
    "${tumor_bam}"

  # NOTE(SW): hard coded since there is no reliable way to obtain version information, see GH issue
  # https://github.com/PapenfussLab/gridss/issues/586
  cat <<-END_VERSIONS > versions.yml
    "${task.process}":
      gridss: 2.13.2
  END_VERSIONS
  """

  stub:
  """
  mkdir -p gridss_assemble/
  echo -e '${task.process}:\\n  stub: noversions\\n' > versions.yml
  """
}