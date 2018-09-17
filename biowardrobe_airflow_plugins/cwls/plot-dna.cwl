cwlVersion: v1.0
class: Workflow


inputs:

  islands_file:
    type: File
    label: "Islands file"
    format: "http://edamontology.org/format_3475"
    doc: "Islands file (Iaintersect TSV or MACS2 XLS output)"

  bambai_pair:
    type: File
    secondaryFiles:
      - .bai
    label: "Coordinate sorted BAM+BAI files"
    format: "http://edamontology.org/format_2572"
    doc: "Coordinate sorted BAM file and BAI index file"

  output_prefix:
    type: string?
    label: "Output file prefix"
    doc: "Output file prefix"


outputs:

  png_file:
    type: File[]
    label: "PNG plots"
    format: "http://edamontology.org/format_3603"
    doc: "R generated ChIP-Seq results plots"
    outputSource: plot_dna/png_file

  pileup_file:
    type: File
    label: "Pileaup"
    format: "http://edamontology.org/format_3475"
    doc: "Ranked peak number plot data"
    outputSource: plot_dna/pileup_file

  length_file:
    type: File
    label: "Length"
    format: "http://edamontology.org/format_3475"
    doc: "Islands length distribution histogram data"
    outputSource: plot_dna/length_file

  reads_file:
    type: File
    label: "Reads"
    format: "http://edamontology.org/format_3475"
    doc: "Chromosomal reads distribution barplot data"
    outputSource: plot_dna/reads_file


steps:

  plot_dna:
    in:
      islands_file: islands_file
      bambai_pair: bambai_pair
      output_prefix: output_prefix
    out: [png_file, pileup_file, length_file, reads_file]
    run:
      cwlVersion: v1.0
      class: CommandLineTool
      requirements:
      - class: InlineJavascriptRequirement
        expressionLib:
        - var get_output_prefix = function(ext) {
              ext = ext || "";
              if (inputs.output_prefix == ""){
                let root = inputs.bambai_pair.basename.split('.').slice(0,-1).join('.');
                return (root == "")?inputs.bambai_pair.basename+ext:root+ext;
              } else {
                return inputs.output_prefix;
              }
          }
      - class: DockerRequirement
        dockerPull: biowardrobe2/plugin-plot-dna:v0.0.1
      inputs:
        islands_file:
          type: File
          inputBinding:
            position: 5
            prefix: "-i"
          doc: "Islands file (Iaintersect TSV or MACS2 XLS output)"
        bambai_pair:
          type: File
          inputBinding:
            position: 6
            prefix: "-b"
          secondaryFiles:
            - .bai
          doc: "Indexed BAM + BAI files"
        output_prefix:
          type: string?
          inputBinding:
            position: 9
            prefix: "-o"
            valueFrom: $(get_output_prefix("_default_"))
          default: ""
          doc: "Output file prefix"
      outputs:
        png_file:
          type: File[]
          outputBinding:
            glob: "*.png"
        pileup_file:
          type: File
          outputBinding:
            glob: "*pileup.tsv"
        length_file:
          type: File
          outputBinding:
            glob: "*length.tsv"
        reads_file:
          type: File
          outputBinding:
            glob: "*reads.tsv"
      baseCommand: ["plot_dna.R"]
