{
    "$graph": [
        {
            "class": "CommandLineTool",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/scidap:v0.0.3"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "File",
                        {
                            "type": "array",
                            "items": "File"
                        }
                    ],
                    "inputBinding": {
                        "position": 2
                    },
                    "id": "#custom-bash.cwl/input_file"
                },
                {
                    "type": [
                        "null",
                        "string",
                        {
                            "type": "array",
                            "items": "string"
                        }
                    ],
                    "inputBinding": {
                        "position": 3
                    },
                    "id": "#custom-bash.cwl/param"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "default": "cat \"$0\" | grep \"$1\" | sed \"s/$1//g\"  > `basename $0`\n",
                    "inputBinding": {
                        "position": 1
                    },
                    "id": "#custom-bash.cwl/script"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "*"
                    },
                    "id": "#custom-bash.cwl/output_file"
                }
            ],
            "baseCommand": [
                "bash",
                "-c"
            ],
            "doc": "Tool to run custom script set as `script` input with arguments from `param`.\nDefault script runs sed command over the input file and exports results to the file with the same name as input's basename\n",
            "id": "#custom-bash.cwl",
            "http://schema.org/name": "custom-bash",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/custom-bash.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:michael.kotliar@cchmc.org",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "id": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "Custom bash script runner",
            "$namespaces": {
                "s": "http://schema.org/"
            }
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement",
                    "expressionLib": [
                        "var default_output_filename = function(ext) { let root = inputs.input_filename.basename.split('.').slice(0,-1).join('.'); return (root == \"\")?inputs.input_filename.basename+ext:root+ext; };"
                    ]
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/iaintersect:v0.0.2"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "File"
                    ],
                    "inputBinding": {
                        "position": 2,
                        "prefix": "--a=",
                        "separate": false
                    },
                    "doc": "Annotation file, tsv\n",
                    "id": "#iaintersect.cwl/annotation_filename"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 7,
                        "prefix": "--sam_ignorechr=",
                        "separate": false
                    },
                    "doc": "The chromosome to be ignored, string\n",
                    "id": "#iaintersect.cwl/ignore_chr"
                },
                {
                    "type": [
                        "File"
                    ],
                    "inputBinding": {
                        "position": 1,
                        "prefix": "--in=",
                        "separate": false
                    },
                    "doc": "Input filename with MACS2 peak calling results, tsv\n",
                    "id": "#iaintersect.cwl/input_filename"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 4,
                        "prefix": "--log=",
                        "separate": false,
                        "valueFrom": "${\n    if (self == null){\n      return default_output_filename('_iaintersect.log');\n    } else {\n      return self;\n    }\n}\n"
                    },
                    "default": null,
                    "doc": "Log filename\n",
                    "id": "#iaintersect.cwl/log_filename"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 3,
                        "prefix": "--out=",
                        "separate": false,
                        "valueFrom": "${\n    if (self == null){\n      return default_output_filename('_iaintersect.tsv');\n    } else {\n      return self;\n    }\n}\n"
                    },
                    "default": null,
                    "doc": "Base output file name, tsv\n",
                    "id": "#iaintersect.cwl/output_filename"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "position": 5,
                        "prefix": "--promoter=",
                        "separate": false
                    },
                    "doc": "Promoter region around TSS, base pairs\n",
                    "id": "#iaintersect.cwl/promoter_bp"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "position": 6,
                        "prefix": "--upstream=",
                        "separate": false
                    },
                    "doc": "Upstream region before promoter, base pairs\n",
                    "id": "#iaintersect.cwl/upstream_bp"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "${\n  if (inputs.log_filename == null){\n    return default_output_filename('_iaintersect.log');\n  } else {\n    return inputs.log_filename;\n  }\n}\n"
                    },
                    "id": "#iaintersect.cwl/log_file"
                },
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "${\n  if (inputs.output_filename == null){\n    return default_output_filename('_iaintersect.tsv');\n  } else {\n    return inputs.output_filename;\n  }\n}\n"
                    },
                    "id": "#iaintersect.cwl/result_file"
                }
            ],
            "baseCommand": [
                "iaintersect"
            ],
            "doc": "Tool assigns each peak obtained from MACS2 to a gene and region (upstream, promoter, exon, intron, intergenic)\n\n`default_output_filename` function returns output filename with sufix set as `ext` argument. Function is called when\neither `output_filename` or `log_filename` inputs are not provided.\n",
            "id": "#iaintersect.cwl",
            "http://schema.org/mainEntity": {
                "class": "http://schema.org/SoftwareSourceCode",
                "id": "#iaintersect-metadata.yaml",
                "name": "#iaintersect-metadata.yaml",
                "http://schema.org/name": "iaintersect",
                "http://schema.org/about": "Based on BioWardrobe iaintersect (https://github.com/cincinnati-childrens-hospital/biowardrobe/tree/master/src/iaintersect) The software assigns each peak obtained from MACS2 to a gene and region (upstream, promoter, exon, intron, intergenic).\n",
                "http://schema.org/url": "https://github.com/Barski-lab/iaintersect/blob/master/README.md",
                "http://schema.org/codeRepository": "https://github.com/Barski-lab/iaintersect",
                "http://schema.org/license": [
                    "https://opensource.org/licenses/MIT"
                ],
                "http://schema.org/targetProduct": {
                    "class": "http://schema.org/SoftwareApplication",
                    "http://schema.org/softwareVersion": "0.0.1",
                    "http://schema.org/applicationCategory": "command line tool"
                },
                "http://schema.org/programmingLanguage": "C++",
                "http://schema.org/discussionUrl": [
                    "https://github.com/Barski-lab/iaintersect/issues"
                ],
                "http://schema.org/creator": [
                    {
                        "class": "http://schema.org/Organization",
                        "http://schema.org/name": "Barski Research Lab",
                        "http://schema.org/member": [
                            {
                                "class": "http://schema.org/Person",
                                "http://schema.org/name": "Andrey Kartashov",
                                "http://schema.org/description": "Main author"
                            },
                            {
                                "class": "http://schema.org/Person",
                                "http://schema.org/name": "Michael Kotliar",
                                "http://schema.org/description": "Update to work with files instead of DB"
                            }
                        ]
                    }
                ]
            },
            "http://schema.org/name": "iaintersect",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/iaintersect.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "Usage:\n  iaintersect [options] --in=pathToFile --a=pathtoFile --out=pathToFile\n  --a                        \tTab-separated annotation file\n  --in                       \tInput filename with MACS2 peak calling results, xls\n  --log                      \tLog filename (default is ./logfile_def.log)\n  --out                      \tBase output file name\n  --promoter                 \tPromoter region around TSS in bp\n  --sam_ignorechr            \tThe chromosome to be ignored\n  --upstream                 \tUpstream region before promoter in bp\n"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement",
                    "expressionLib": [
                        "var default_output_filename = function() { return inputs.unsorted_file.location.split('/').slice(-1)[0]; };"
                    ]
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/scidap:v0.0.2"
                }
            ],
            "inputs": [
                {
                    "type": {
                        "type": "array",
                        "items": "string",
                        "inputBinding": {
                            "prefix": "-k"
                        }
                    },
                    "inputBinding": {
                        "position": 1
                    },
                    "doc": "-k, --key=POS1[,POS2]\nstart a key at POS1, end it at POS2 (origin 1)\n",
                    "id": "#linux-sort.cwl/key"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "doc": "Name for generated output file\n",
                    "id": "#linux-sort.cwl/output_filename"
                },
                {
                    "type": "File",
                    "inputBinding": {
                        "position": 4
                    },
                    "id": "#linux-sort.cwl/unsorted_file"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "${\n  if (inputs.output_filename == null){\n    return default_output_filename();\n  } else {\n    return inputs.output_filename;\n  }\n}\n"
                    },
                    "doc": "Sorted file\n",
                    "id": "#linux-sort.cwl/sorted_file"
                }
            ],
            "stdout": "${\n  if (inputs.output_filename == null){\n    return default_output_filename();\n  } else {\n    return inputs.output_filename;\n  }\n}\n",
            "baseCommand": [
                "sort"
            ],
            "doc": "Tool sorts data from `unsorted_file` by key\n\n`default_output_filename` function returns file name identical to `unsorted_file`, if `output_filename` is not provided.\n",
            "id": "#linux-sort.cwl",
            "http://schema.org/name": "linux-sort",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/linux-sort.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Andrey Kartashov",
                                            "http://schema.org/email": "mailto:Andrey.Kartashov@cchmc.org",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "id": "#0000-0001-9102-5681"
                                                }
                                            ]
                                        },
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement",
                    "expressionLib": [
                        "var default_output_filename = function() { if (inputs.output_filename == null){ let ext = \".gff\"; let root = inputs.islands_file.basename.split('.').slice(0,-1).join('.'); return (root == \"\")?inputs.islands_file.basename+ext:root+ext; } else { return inputs.output_filename; } };"
                    ]
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/scidap-addons:v0.0.5"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "position": 7
                    },
                    "doc": "Control tab-delimited file (output from iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl tool)\n",
                    "id": "#makegff.cwl/islands_control_file"
                },
                {
                    "type": "File",
                    "inputBinding": {
                        "position": 5
                    },
                    "doc": "Input tab-delimited file (output from iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl tool)\n",
                    "id": "#makegff.cwl/islands_file"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 6,
                        "valueFrom": "$(default_output_filename())"
                    },
                    "default": null,
                    "id": "#makegff.cwl/output_filename"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(default_output_filename())"
                    },
                    "id": "#makegff.cwl/gff_file"
                }
            ],
            "baseCommand": [
                "makegff"
            ],
            "doc": "Tool produces GFF output from the file generated by iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl tool\nBoth islands_file and islands_control_file should be produced by the same tool\n",
            "id": "#makegff.cwl",
            "http://schema.org/mainEntity": {
                "class": "http://schema.org/SoftwareSourceCode",
                "id": "#makegff-metadata.yaml",
                "name": "#makegff-metadata.yaml",
                "http://schema.org/name": "makegff",
                "http://schema.org/about": "makegff R script\n"
            },
            "http://schema.org/name": "makegff",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/makegff.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "Tool produces GFF output from the file generated by iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl tool\n"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement",
                    "expressionLib": [
                        "var get_target_name = function() { return inputs.target_filename.split('/').slice(-1)[0]; }"
                    ]
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/scidap:v0.0.2"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "default": "#!/bin/bash\ncp $0 $1\nif [ -f $0.bai ]; then\n  cp $0.bai $1.bai\nfi\n",
                    "inputBinding": {
                        "position": 1
                    },
                    "id": "#rename.cwl/script"
                },
                {
                    "type": [
                        "File"
                    ],
                    "inputBinding": {
                        "position": 5
                    },
                    "id": "#rename.cwl/source_file"
                },
                {
                    "type": "string",
                    "inputBinding": {
                        "position": 6,
                        "valueFrom": "$(get_target_name())"
                    },
                    "id": "#rename.cwl/target_filename"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(get_target_name())"
                    },
                    "secondaryFiles": "${\n    if (inputs.source_file.secondaryFiles && inputs.source_file.secondaryFiles.length > 0){\n      return inputs.target_filename+\".bai\";\n    } else {\n      return \"null\";\n    }\n  }\n",
                    "id": "#rename.cwl/target_file"
                }
            ],
            "baseCommand": [
                "bash",
                "-c"
            ],
            "doc": "Tool renames `source_file` to `target_filename`.\nInput `target_filename` should be set as string. If it's a full path, only basename will be used.\nIf BAI file is present, it will be renamed too\n",
            "id": "#rename.cwl",
            "http://schema.org/name": "rename",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/rename.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "cp source target"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/scidap-addons:v0.0.5"
                }
            ],
            "inputs": [
                {
                    "type": "File",
                    "inputBinding": {
                        "position": 7,
                        "prefix": "-g"
                    },
                    "doc": "TSV genome annotation file\n",
                    "id": "#rose.cwl/annotation_file"
                },
                {
                    "type": "File",
                    "inputBinding": {
                        "position": 6,
                        "prefix": "-r"
                    },
                    "secondaryFiles": [
                        ".bai"
                    ],
                    "doc": "Indexed bamfile to rank enhancer by\n",
                    "id": "#rose.cwl/bam_file"
                },
                {
                    "type": "File",
                    "inputBinding": {
                        "position": 5,
                        "prefix": "-i"
                    },
                    "doc": "GFF or BED file of binding sites used to make enhancers\n",
                    "id": "#rose.cwl/binding_sites_file"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "position": 8,
                        "prefix": "-s"
                    },
                    "doc": "Linking distance for stitching\n",
                    "id": "#rose.cwl/stitch_distance"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "position": 9,
                        "prefix": "-t"
                    },
                    "doc": "Distance from TSS to exclude. 0 = no TSS exclusion\n",
                    "id": "#rose.cwl/tss_distance"
                }
            ],
            "outputs": [
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*AllEnhancers.table.txt"
                    },
                    "id": "#rose.cwl/all_enhancers_table"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*Enhancers_withSuper.bed"
                    },
                    "id": "#rose.cwl/enhancers_with_super_bed"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*Gateway_Enhancers.bed"
                    },
                    "id": "#rose.cwl/gateway_enhancers_bed"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*Gateway_SuperEnhancers.bed"
                    },
                    "id": "#rose.cwl/gateway_super_enhancers_bed"
                },
                {
                    "type": "Directory",
                    "outputBinding": {
                        "glob": "gff"
                    },
                    "id": "#rose.cwl/gff_directory"
                },
                {
                    "type": "Directory",
                    "outputBinding": {
                        "glob": "mappedGFF"
                    },
                    "id": "#rose.cwl/mapped_gff_directory"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*Plot_points.png"
                    },
                    "id": "#rose.cwl/plot_points_pic"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*STITCHED_TSS_DISTAL_ENHANCER_REGION_MAP.txt"
                    },
                    "id": "#rose.cwl/stitched_enhancer_region_map"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "outputBinding": {
                        "glob": "*SuperEnhancers.table.txt"
                    },
                    "id": "#rose.cwl/super_enhancers_table"
                }
            ],
            "baseCommand": [
                "ROSE_main",
                "-o",
                "./"
            ],
            "doc": "-b and -c arguments are not supported\n",
            "id": "#rose.cwl",
            "http://schema.org/mainEntity": {
                "class": "http://schema.org/SoftwareSourceCode",
                "id": "#rose-metadata.yaml",
                "name": "#rose-metadata.yaml",
                "http://schema.org/name": "ROSE",
                "http://schema.org/about": "RANK ORDERING OF SUPER-ENHANCERS\n"
            },
            "http://schema.org/name": "rose",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/rose.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "Updated version of the original ROSE\n"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement",
                    "expressionLib": [
                        "var default_output_filename = function() { return inputs.input_bed.location.split('/').slice(-1)[0].split('.').slice(0,-1).join('.')+\".bb\"; };",
                        "var get_bed_type = function() { if (inputs.input_bed.location.split('.').slice(-1)[0].toLowerCase() == \"narrowpeak\"){ return \"bed6+4\"; } else if (inputs.input_bed.location.split('.').slice(-1)[0].toLowerCase() == \"broadpeak\"){ return \"bed6+3\"; } else { return null; } };",
                        "var get_bed_template = function() { if (inputs.input_bed.location.split('.').slice(-1)[0].toLowerCase() == \"narrowpeak\"){ return \"narrowpeak.as\"; } else if (inputs.input_bed.location.split('.').slice(-1)[0].toLowerCase() == \"broadpeak\"){ return \"broadpeak.as\"; } else { return null; } };"
                    ]
                },
                {
                    "class": "InitialWorkDirRequirement",
                    "listing": [
                        {
                            "entryname": "narrowpeak.as",
                            "entry": "table narrowPeak\n\"BED6+4 Peaks of signal enrichment based on pooled, normalized (interpreted) data.\"\n(\n  string  chrom;        \"Reference sequence chromosome or scaffold\"\n  uint    chromStart;   \"Start position in chromosome\"\n  uint    chromEnd;     \"End position in chromosome\"\n  string  name;\t        \"Name given to a region (preferably unique). Use . if no name is assigned\"\n  uint    score;        \"Indicates how dark the peak will be displayed in the browser (0-1000) \"\n  char[1] strand;       \"+ or - or . for unknown\"\n  float   signalValue;  \"Measurement of average enrichment for the region\"\n  float   pValue;       \"Statistical significance of signal value (-log10). Set to -1 if not used.\"\n  float   qValue;       \"Statistical significance with multiple-test correction applied (FDR -log10). Set to -1 if not used.\"\n  int     peak;         \"Point-source called for this peak; 0-based offset from chromStart. Set to -1 if no point-source called.\"\n)\n"
                        },
                        {
                            "entryname": "broadpeak.as",
                            "entry": "table broadPeak\n\"BED6+3 Peaks of signal enrichment based on pooled, normalized (interpreted) data.\"\n(\n  string  chrom;        \"Reference sequence chromosome or scaffold\"\n  uint    chromStart;   \"Start position in chromosome\"\n  uint    chromEnd;     \"End position in chromosome\"\n  string  name;\t        \"Name given to a region (preferably unique). Use . if no name is assigned.\"\n  uint    score;        \"Indicates how dark the peak will be displayed in the browser (0-1000)\"\n  char[1] strand;       \"+ or - or . for unknown\"\n  float   signalValue;  \"Measurement of average enrichment for the region\"\n  float   pValue;       \"Statistical significance of signal value (-log10). Set to -1 if not used.\"\n  float   qValue;       \"Statistical significance with multiple-test correction applied (FDR -log10). Set to -1 if not used.\"\n)\n"
                        }
                    ]
                }
            ],
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biowardrobe2/ucscuserapps:v358"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "position": 6,
                        "prefix": "-as=",
                        "separate": false,
                        "valueFrom": "${\n    if (self == null){\n      return get_bed_template();\n    } else {\n      return self;\n    }\n}\n"
                    },
                    "default": null,
                    "doc": "For non-standard \"bedPlus\" fields put a definition of each field in a row in AutoSql format.\nBy default includes only three required BED fields: chrom, chromStart, chromEnd\n",
                    "id": "#ucsc-bedtobigbed.cwl/bed_template"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 5,
                        "prefix": "-type=",
                        "separate": false,
                        "valueFrom": "${\n    if (self == null){\n      return get_bed_type();\n    } else {\n      return self;\n    }\n}\n"
                    },
                    "default": null,
                    "doc": "Type of BED file in a form of bedN[+[P]]. By default bed3 to three required BED fields\n",
                    "id": "#ucsc-bedtobigbed.cwl/bed_type"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "position": 7,
                        "prefix": "-blockSize=",
                        "separate": false
                    },
                    "doc": "Number of items to bundle in r-tree.  Default 256\n",
                    "id": "#ucsc-bedtobigbed.cwl/block_size"
                },
                {
                    "type": [
                        "File"
                    ],
                    "inputBinding": {
                        "position": 21
                    },
                    "doc": "Chromosome length files\n",
                    "id": "#ucsc-bedtobigbed.cwl/chrom_length_file"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 11,
                        "prefix": "-extraIndex=",
                        "separate": false
                    },
                    "doc": "Makes an index on each field in a comma separated list extraIndex=name and extraIndex=name,id are commonly used\n",
                    "id": "#ucsc-bedtobigbed.cwl/extra_index"
                },
                {
                    "type": [
                        "File"
                    ],
                    "inputBinding": {
                        "position": 20
                    },
                    "doc": "Input BED file\n",
                    "id": "#ucsc-bedtobigbed.cwl/input_bed"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "position": 8,
                        "prefix": "-itemsPerSlot=",
                        "separate": false
                    },
                    "doc": "Number of data points bundled at lowest level. Default 512\n",
                    "id": "#ucsc-bedtobigbed.cwl/items_per_slot"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "position": 22,
                        "valueFrom": "${\n    if (self == null){\n      return default_output_filename();\n    } else {\n      return self;\n    }\n}\n"
                    },
                    "default": null,
                    "doc": "Output filename\n",
                    "id": "#ucsc-bedtobigbed.cwl/output_filename"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "position": 12,
                        "prefix": "-sizesIs2Bit=",
                        "separate": false
                    },
                    "doc": "If set, the chrom.sizes file is assumed to be a 2bit file\n",
                    "id": "#ucsc-bedtobigbed.cwl/size_2bit"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "position": 10,
                        "prefix": "-tab"
                    },
                    "doc": "If set, expect fields to be tab separated, normally expects white space separator\n",
                    "id": "#ucsc-bedtobigbed.cwl/tab_sep"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "position": 9,
                        "prefix": "-unc"
                    },
                    "doc": "If set, do not use compression\n",
                    "id": "#ucsc-bedtobigbed.cwl/unc"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "outputBinding": {
                        "glob": "${\n  if (inputs.output_filename == null){\n    return default_output_filename();\n  } else {\n    return inputs.output_filename;\n  }\n}\n"
                    },
                    "id": "#ucsc-bedtobigbed.cwl/bigbed_file"
                }
            ],
            "baseCommand": [
                "bedToBigBed"
            ],
            "doc": "Tool converts bed file to bigBed\n\nBefore running `baseCommand` the following files are created in Docker working directory (using\n`InitialWorkDirRequirement`):\n`narrowpeak.as` - default BED file structure template for ENCODE narrowPeak format\n`broadpeak.as`  - default BED file structure template for ENCODE broadPeak format\n\n`default_output_filename` function returns default output file name based on `input_bed` basename with `*.bb`\nextension if `output_filename` is not provided.\n\n`get_bed_type` function returns default BED file type if `bed_type` is not provided. Depending on `input_bed` file\nextension the following values are returned:\n  `*.narrowpeak`  -->   bed6+4\n  `*.broadpeak`   -->   bed6+3\n   else           -->   null (`bedToBigBed` will use its own default value)\n\n`get_bed_template` function returns default BED file template if `bed_template` is not provided. Depending on\n`input_bed` file extension the following values are returned:\n    `*.narrowpeak`  -->   narrowpeak.as (previously staged into Docker working directory)\n    `*.broadpeak`   -->   broadpeak.as (previously staged into Docker working directory)\n     else           -->   null (`bedToBigBed` will use its own default value)\n",
            "id": "#ucsc-bedtobigbed.cwl",
            "http://schema.org/mainEntity": {
                "class": "http://schema.org/SoftwareSourceCode",
                "id": "#ucsc-metadata.yaml",
                "name": "#ucsc-metadata.yaml",
                "http://schema.org/name": "UCSC userApps",
                "http://schema.org/about": "UCSC genome browser bioinformatic utilities\n",
                "http://schema.org/url": "https://genome.ucsc.edu/util.html",
                "http://schema.org/targetProduct": {
                    "class": "http://schema.org/SoftwareApplication",
                    "http://schema.org/softwareVersion": "v358",
                    "http://schema.org/applicationCategory": "commandline tool",
                    "http://schema.org/downloadURL": "http://hgdownload.cse.ucsc.edu/admin/exe/userApps.v358.src.tgz"
                },
                "http://schema.org/programmingLanguage": "C++",
                "http://schema.org/license": [
                    "https://opensource.org/licenses/GPL-3.0"
                ]
            },
            "http://schema.org/name": "ucsc-bedtobigbed",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/ucsc-bedtobigbed.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "usage:\n   bedToBigBed in.bed chrom.sizes out.bb\nWhere in.bed is in one of the ascii bed formats, but not including track lines\nand chrom.sizes is a two-column file/URL: <chromosome name> <size in bases>\nand out.bb is the output indexed big bed file.\nIf the assembly <db> is hosted by UCSC, chrom.sizes can be a URL like\n  http://hgdownload.cse.ucsc.edu/goldenPath/<db>/bigZips/<db>.chrom.sizes\nor you may use the script fetchChromSizes to download the chrom.sizes file.\nIf not hosted by UCSC, a chrom.sizes file can be generated by running\ntwoBitInfo on the assembly .2bit file.\nThe in.bed file must be sorted by chromosome,start,\n  to sort a bed file, use the unix sort command:\n     sort -k1,1 -k2,2n unsorted.bed > sorted.bed\nSorting must be set to skip Unicode mapping (LC_COLLATE=C).\n\noptions:\n   -type=bedN[+[P]] :\n                      N is between 3 and 15,\n                      optional (+) if extra \"bedPlus\" fields,\n                      optional P specifies the number of extra fields. Not required, but preferred.\n                      Examples: -type=bed6 or -type=bed6+ or -type=bed6+3\n                      (see http://genome.ucsc.edu/FAQ/FAQformat.html#format1)\n   -as=fields.as - If you have non-standard \"bedPlus\" fields, it's great to put a definition\n                   of each field in a row in AutoSql format here.\n   -blockSize=N - Number of items to bundle in r-tree.  Default 256\n   -itemsPerSlot=N - Number of data points bundled at lowest level. Default 512\n   -unc - If set, do not use compression.\n   -tab - If set, expect fields to be tab separated, normally\n           expects white space separator.\n   -extraIndex=fieldList - If set, make an index on each field in a comma separated list\n           extraIndex=name and extraIndex=name,id are commonly used.\n   -sizesIs2Bit  -- If set, the chrom.sizes file is assumed to be a 2bit file.\n   -udcDir=/path/to/udcCacheDir  -- sets the UDC cache dir for caching of remote files.\n"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "SubworkflowFeatureRequirement"
                },
                {
                    "class": "StepInputExpressionRequirement"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "MultipleInputFeatureRequirement"
                }
            ],
            "inputs": [
                {
                    "type": "File",
                    "label": "Annotation file",
                    "format": "http://edamontology.org/format_3475",
                    "doc": "Tab-separated input annotation file",
                    "id": "#main/annotation_file"
                },
                {
                    "type": "File",
                    "secondaryFiles": [
                        ".bai"
                    ],
                    "label": "Coordinate sorted BAM alignment file (+index BAI)",
                    "format": "http://edamontology.org/format_2572",
                    "doc": "Coordinate sorted BAM file and BAI index file",
                    "id": "#main/bambai_pair"
                },
                {
                    "type": "File",
                    "label": "Chromosome length file",
                    "format": "http://edamontology.org/format_2330",
                    "doc": "Chromosome length file",
                    "id": "#main/chrom_length_file"
                },
                {
                    "type": [
                        "null",
                        "File"
                    ],
                    "label": "XLS called peaks file (control)",
                    "format": "http://edamontology.org/format_3468",
                    "doc": "XLS file to include information about peaks returned by iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl for control",
                    "id": "#main/islands_control_file"
                },
                {
                    "type": "File",
                    "label": "XLS called peaks file",
                    "format": "http://edamontology.org/format_3468",
                    "doc": "XLS file to include information about peaks returned by iaintersect.cwl or macs2-callpeak-biowardrobe-only.cwl",
                    "id": "#main/islands_file"
                },
                {
                    "type": "int",
                    "label": "Promoter distance",
                    "doc": "Promoter distance for gene names assignment",
                    "id": "#main/promoter_bp"
                },
                {
                    "type": "int",
                    "label": "Stitching distance",
                    "doc": "Linking distance for stitching",
                    "id": "#main/stitch_distance"
                },
                {
                    "type": "int",
                    "label": "TSS distance",
                    "doc": "Distance from TSS to exclude, 0 = no TSS exclusion",
                    "id": "#main/tss_distance"
                }
            ],
            "outputs": [
                {
                    "type": "File",
                    "label": "Gateway Super Enhancer bigBed file",
                    "format": "http://edamontology.org/format_3475",
                    "doc": "Gateway Super Enhancer bigBed file",
                    "outputSource": "#main/bed_to_bigbed/bigbed_file",
                    "id": "#main/bigbed_file"
                },
                {
                    "type": "File",
                    "label": "Gateway Super Enhancer results from ROSE with gene names",
                    "format": "http://edamontology.org/format_3475",
                    "doc": "Gateway Super Enhancer results from ROSE with assigned gene names",
                    "outputSource": "#main/add_island_names/output_file",
                    "id": "#main/gene_names_file"
                },
                {
                    "type": "File",
                    "label": "ROSE visualization plot",
                    "format": "http://edamontology.org/format_3603",
                    "doc": "Generated by ROSE visualization plot",
                    "outputSource": "#main/rename_png/target_file",
                    "id": "#main/png_file"
                }
            ],
            "steps": [
                {
                    "run": "#custom-bash.cwl",
                    "in": [
                        {
                            "source": [
                                "#main/assign_genes/result_file",
                                "#main/sort_bed/sorted_file"
                            ],
                            "id": "#main/add_island_names/input_file"
                        },
                        {
                            "source": "#main/bambai_pair",
                            "valueFrom": "$(self.location.split('/').slice(-1)[0].split('.').slice(0,-1).join('.')+\"_super_enhancer.tsv\")",
                            "id": "#main/add_island_names/param"
                        },
                        {
                            "default": "echo -e \"refseq_id\\tgene_id\\ttxStart\\ttxEnd\\tstrand\\tchrom\\tstart\\tend\\tlength\\tregion\\tname\\tscore\" > `basename $2`;\ncat $0 | grep -v refseq_id | paste - $1 | cut -f 1-9,15,19,20 >> `basename $2`\n",
                            "id": "#main/add_island_names/script"
                        }
                    ],
                    "out": [
                        "#main/add_island_names/output_file"
                    ],
                    "id": "#main/add_island_names"
                },
                {
                    "run": "#iaintersect.cwl",
                    "in": [
                        {
                            "source": "#main/annotation_file",
                            "id": "#main/assign_genes/annotation_filename"
                        },
                        {
                            "source": "#main/bed_to_macs/output_file",
                            "id": "#main/assign_genes/input_filename"
                        },
                        {
                            "source": "#main/promoter_bp",
                            "id": "#main/assign_genes/promoter_bp"
                        }
                    ],
                    "out": [
                        "#main/assign_genes/result_file"
                    ],
                    "id": "#main/assign_genes"
                },
                {
                    "run": "#ucsc-bedtobigbed.cwl",
                    "in": [
                        {
                            "default": "bed6",
                            "id": "#main/bed_to_bigbed/bed_type"
                        },
                        {
                            "source": "#main/chrom_length_file",
                            "id": "#main/bed_to_bigbed/chrom_length_file"
                        },
                        {
                            "source": "#main/sort_bed/sorted_file",
                            "id": "#main/bed_to_bigbed/input_bed"
                        },
                        {
                            "source": "#main/bambai_pair",
                            "valueFrom": "$(self.location.split('/').slice(-1)[0].split('.').slice(0,-1).join('.')+\"_super_enhancer.bb\")",
                            "id": "#main/bed_to_bigbed/output_filename"
                        }
                    ],
                    "out": [
                        "#main/bed_to_bigbed/bigbed_file"
                    ],
                    "id": "#main/bed_to_bigbed"
                },
                {
                    "run": "#custom-bash.cwl",
                    "in": [
                        {
                            "source": "#main/sort_bed/sorted_file",
                            "id": "#main/bed_to_macs/input_file"
                        },
                        {
                            "default": "cat $0 | grep -v \"#\" | awk 'BEGIN {print \"chr\\tstart\\tend\\tlength\\tabs_summit\\tpileup\\t-log10(pvalue)\\tfold_enrichment\\t-log10(qvalue)\\tname\"} {print $1\"\\t\"$2\"\\t\"$3\"\\t\"$3-$2+1\"\\t0\\t0\\t0\\t0\\t0\\t\"$4}' > `basename $0`\n",
                            "id": "#main/bed_to_macs/script"
                        }
                    ],
                    "out": [
                        "#main/bed_to_macs/output_file"
                    ],
                    "id": "#main/bed_to_macs"
                },
                {
                    "run": "#makegff.cwl",
                    "in": [
                        {
                            "source": "#main/islands_control_file",
                            "id": "#main/make_gff/islands_control_file"
                        },
                        {
                            "source": "#main/islands_file",
                            "id": "#main/make_gff/islands_file"
                        }
                    ],
                    "out": [
                        "#main/make_gff/gff_file"
                    ],
                    "id": "#main/make_gff"
                },
                {
                    "run": "#rename.cwl",
                    "in": [
                        {
                            "source": "#main/run_rose/plot_points_pic",
                            "id": "#main/rename_png/source_file"
                        },
                        {
                            "source": "#main/bambai_pair",
                            "valueFrom": "$(self.location.split('/').slice(-1)[0].split('.').slice(0,-1).join('.')+\"_super_enhancer.png\")",
                            "id": "#main/rename_png/target_filename"
                        }
                    ],
                    "out": [
                        "#main/rename_png/target_file"
                    ],
                    "id": "#main/rename_png"
                },
                {
                    "run": "#rose.cwl",
                    "in": [
                        {
                            "source": "#main/annotation_file",
                            "id": "#main/run_rose/annotation_file"
                        },
                        {
                            "source": "#main/bambai_pair",
                            "id": "#main/run_rose/bam_file"
                        },
                        {
                            "source": "#main/make_gff/gff_file",
                            "id": "#main/run_rose/binding_sites_file"
                        },
                        {
                            "source": "#main/stitch_distance",
                            "id": "#main/run_rose/stitch_distance"
                        },
                        {
                            "source": "#main/tss_distance",
                            "id": "#main/run_rose/tss_distance"
                        }
                    ],
                    "out": [
                        "#main/run_rose/plot_points_pic",
                        "#main/run_rose/gateway_super_enhancers_bed"
                    ],
                    "id": "#main/run_rose"
                },
                {
                    "run": "#linux-sort.cwl",
                    "in": [
                        {
                            "default": [
                                "1,1",
                                "2,2n",
                                "3,3n"
                            ],
                            "id": "#main/sort_bed/key"
                        },
                        {
                            "source": "#main/run_rose/gateway_super_enhancers_bed",
                            "id": "#main/sort_bed/unsorted_file"
                        }
                    ],
                    "out": [
                        "#main/sort_bed/sorted_file"
                    ],
                    "id": "#main/sort_bed"
                }
            ],
            "doc": "Both `islands_file` and `islands_control_file` should be produced by the same cwl tool (iaintersect.cwl or\nmacs2-callpeak-biowardrobe-only.cwl)\n",
            "id": "#main",
            "http://schema.org/name": "super-enhancer",
            "http://schema.org/downloadUrl": "https://raw.githubusercontent.com/Barski-lab/workflows/master/workflows/super-enhancer.cwl",
            "http://schema.org/codeRepository": "https://github.com/Barski-lab/workflows",
            "http://schema.org/license": "http://www.apache.org/licenses/LICENSE-2.0",
            "http://schema.org/isPartOf": {
                "class": "http://schema.org/CreativeWork",
                "http://schema.org/name": "Common Workflow Language",
                "http://schema.org/url": "http://commonwl.org/"
            },
            "http://schema.org/creator": [
                {
                    "class": "http://schema.org/Organization",
                    "http://schema.org/legalName": "Cincinnati Children's Hospital Medical Center",
                    "http://schema.org/location": [
                        {
                            "class": "http://schema.org/PostalAddress",
                            "http://schema.org/addressCountry": "USA",
                            "http://schema.org/addressLocality": "Cincinnati",
                            "http://schema.org/addressRegion": "OH",
                            "http://schema.org/postalCode": "45229",
                            "http://schema.org/streetAddress": "3333 Burnet Ave",
                            "http://schema.org/telephone": "+1(513)636-4200"
                        }
                    ],
                    "http://schema.org/logo": "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png",
                    "http://schema.org/department": [
                        {
                            "class": "http://schema.org/Organization",
                            "http://schema.org/legalName": "Allergy and Immunology",
                            "http://schema.org/department": [
                                {
                                    "class": "http://schema.org/Organization",
                                    "http://schema.org/legalName": "Barski Research Lab",
                                    "http://schema.org/member": [
                                        {
                                            "class": "http://schema.org/Person",
                                            "http://schema.org/name": "Michael Kotliar",
                                            "http://schema.org/email": "mailto:misha.kotliar@gmail.com",
                                            "http://schema.org/sameAs": [
                                                {
                                                    "$import": "#0000-0002-6486-3898"
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "http://schema.org/about": "Workflow to run Super Enhancer Analysis"
        }
    ],
    "cwlVersion": "v1.0",
    "$schemas": [
        "http://schema.org/docs/schema_org_rdfa.html"
    ]
}