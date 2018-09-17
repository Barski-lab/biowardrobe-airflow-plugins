cwlVersion: v1.0
class: Workflow


inputs:

  bam_file:
    type: File
    label: "BAM file"
    format: "http://edamontology.org/format_2572"
    doc: "Path to the BAM file"

  macs_log:
    type: File
    label: "MACS2 log file"
    format: "http://edamontology.org/format_2330"
    doc: "Path to the MACS2 log file"

  percentage:
    type:
      - "null"
      - float
      - float[]
    doc: "Target percentage"

  output_prefix:
    type:
      - "null"
      - string
    doc: "Output filename prefix"

  output_suffixes:
    type:
      - "null"
      - string[]
    doc: "Output suffixes for reads, islands, surface and saturation files"


outputs:

  reads_file:
    type: File
    label: "Reads plot"
    format: "http://edamontology.org/format_3603"
    doc: "Total and MACS2 reads plot"
    outputSource: run_satscript/reads_file

  islands_file:
    type: File
    label: "Islands plot"
    format: "http://edamontology.org/format_3603"
    doc: "Islands plot"
    outputSource: run_satscript/islands_file

  surface_file:
    type: File
    label: "Surface plot"
    format: "http://edamontology.org/format_3603"
    doc: "Surface plot"
    outputSource: run_satscript/surface_file

  saturation_file:
    type: File
    label: "Surface plot"
    format: "http://edamontology.org/format_2330"
    doc: "Surface text file"
    outputSource: run_satscript/saturation_file


steps:

  run_satscript:
    in:
      bam_file: bam_file
      macs_log: macs_log
      percentage: percentage
      output_prefix: output_prefix
      output_suffixes: output_suffixes
    out: [reads_file, islands_file, surface_file, saturation_file]
    run:
      cwlVersion: v1.0
      class: CommandLineTool
      requirements:
      - class: InlineJavascriptRequirement
        expressionLib:
        - var get_output_prefix = function(ext) {
              ext = ext || "";
              if (inputs.output_prefix == ""){
                let root = inputs.bam_file.basename.split('.').slice(0,-1).join('.');
                return (root == "")?inputs.bam_file.basename+ext:root+ext;
              } else {
                return inputs.output_prefix;
              }
          };
      - class: DockerRequirement
        dockerPull: biowardrobe2/satscript:v0.0.1
      inputs:
        bam_file:
          type: File
          inputBinding:
            position: 5
            prefix: "-b"
          doc: "Path to the BAM file"
        macs_log:
          type: File
          inputBinding:
            position: 6
            prefix: "-m"
          doc: "Path to the MACS2 log file"
        percentage:
          type:
            - "null"
            - float
            - float[]
          inputBinding:
            position: 7
            prefix: "-p"
          doc: "Target percentage"
        output_prefix:
          type:
            - "null"
            - string
          inputBinding:
            position: 8
            prefix: "-o"
            valueFrom: $(get_output_prefix("_default_"))
          default: ""
          doc: "Output filename prefix"
        output_suffixes:
          type:
            - "null"
            - string[]
          inputBinding:
            position: 9
            prefix: "-s"
          default: ["reads.png", "islands.png", "surface.png", "saturation.txt"]
          doc: |
            Output suffixes for reads, islands, surface and saturation files.
      outputs:
        reads_file:
          type: File
          outputBinding:
            glob: $("*"+inputs.output_suffixes[0])
        islands_file:
          type: File
          outputBinding:
            glob: $("*"+inputs.output_suffixes[1])
        surface_file:
          type: File
          outputBinding:
            glob: $("*"+inputs.output_suffixes[2])
        saturation_file:
          type: File
          outputBinding:
            glob: $("*"+inputs.output_suffixes[3])
      baseCommand: ["SatScript"]