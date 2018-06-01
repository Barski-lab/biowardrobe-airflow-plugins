"""
CHIPSEQ_

COMMON               SE                 PE                 NARROW               BROAD     TRIM_SE       TRIM_PE

bigwig
                     fastx_statistics   fastx_statistics_upstream
                                        fastx_statistics_downstream
bowtie_log
iaintersect_log
iaintersect_result
atdp_log
atdp_result
samtools_rmdup_log
bambai_pair
macs2_called_peaks
                                                           macs2_narrow_peaks
                                                           macs2_peak_summits
                                                                                macs2_broad_peaks
                                                                                macs2_gapped_peak
macs2_moder_r
macs2_log
get_stat_log
macs2_fragment_stat
                                                                                          trim_report
                                                                                                        trim_report_upstream:
                                                                                                        trim_report_downstream:
"""

COMMON = """
  {{
    "bowtie_log": {{
      "location": "{raw_data}/{uid}/{uid}.bw",
      "class": "File"
    }},
    "get_stat_log": {{
      "location": "{raw_data}/{uid}/{uid}.stat",
      "class": "File"
    }}
  }}
"""

CHIP = """
  {{
    "iaintersect_log": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks_iaintersect.log",
      "class": "File"
    }},
    "iaintersect_result": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks_iaintersect.tsv",
      "class": "File"
    }},
    "atdp_log": {{
      "location": "{raw_data}/{uid}/{uid}_atdp.log",
      "class": "File"
    }},
    "atdp_result": {{
      "location": "{raw_data}/{uid}/{uid}_atdp.tsv",
      "class": "File"
    }},
    "samtools_rmdup_log": {{
      "location": "{raw_data}/{uid}/{uid}.rmdup",
      "class": "File"
    }},
    "macs2_called_peaks": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks.xls",
      "class": "File"
    }},
    "macs2_log": {{
      "location": "{raw_data}/{uid}/{uid}_macs.log",
      "class": "File"
    }},
    "macs2_fragment_stat": {{
      "location": "{raw_data}/{uid}/{uid}_fragment_stat.tsv",
      "class": "File"
    }}
  }}
"""

RNA = """
  {{
    "star_final_log": {{
      "location": "{raw_data}/{uid}/{uid}.Log.final.out",
      "class": "File"
    }},
    "star_out_log": {{
      "location": "{raw_data}/{uid}/{uid}.Log.out",
      "class": "File"
    }},
    "star_progress_log": {{
      "location": "{raw_data}/{uid}/{uid}.Log.progress.out",
      "class": "File"
    }},
    "star_sj_log": {{
      "location": "{raw_data}/{uid}/{uid}.SJ.out.tab",
      "class": "File"
    }},
    "rpkm_isoforms": {{
      "location": "{raw_data}/{uid}/{uid}.isoforms.csv",
      "class": "File"
    }}
  }}
"""

NARROW = """
  {{
    "macs2_narrow_peaks": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks.narrowPeak",
      "class": "File"
    }},
    "macs2_peak_summits": {{
      "location": "{raw_data}/{uid}/{uid}_macs_summits.bed",
      "class": "File"
    }}
  }}
"""

BROAD = """
  {{
    "macs2_broad_peaks": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks.broadPeak",
      "class": "File"
    }},
    "macs2_gapped_peak": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks.gappedPeak",
      "class": "File"
    }}
  }}
"""

TRIM_SE = """
  {{
    "trim_report": {{
      "location": "{raw_data}/{uid}/{uid}.fastq_trimming_report.txt",
      "class": "File"
    }}
  }}
"""

TRIM_PE = """
  {{
    "trim_report_upstream": {{
      "location": "{raw_data}/{uid}/{uid}.fastq_trimming_report.txt",
      "class": "File"
    }},
    "trim_report_downstream": {{
      "location": "{raw_data}/{uid}/{uid}_2.fastq_trimming_report.txt",
      "class": "File"
    }}
  }}
"""

ADD_FIELDS = """
  {{
    "promoter": {outputs[promoter]}
  }}
"""

SE = """
  {{
    "fastx_statistics": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }}
  }}
"""

PE = """
  {{
    "fastx_statistics_upstream": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }},
    "fastx_statistics_downstream": {{
      "location": "{raw_data}/{uid}/{uid}_2.fastxstat",
      "class": "File"
    }}
  }}
"""

BIGWIG = """
  {{
    "bigwig": {{
      "location": "{raw_data}/{uid}/{uid}.bigWig",
      "class": "File"
    }}
  }}
"""

BIGWIG_DUTP = """
  {{
    "bigwig_upstream": {{
      "location": "{raw_data}/{uid}/{uid}_upstream.bigWig",
      "class": "File"
    }},
    "bigwig_downstream": {{
      "location": "{raw_data}/{uid}/{uid}_downstream.bigWig",
      "class": "File"
    }}
  }}
"""

BAM = """
  {{
    "bambai_pair": {{
      "location": "{raw_data}/{uid}/{uid}.bam",
      "class": "File",
      "secondaryFiles": [{{
        "location": "{raw_data}/{uid}/{uid}.bam.bai",
        "class": "File"
      }}]
    }}
  }}
"""

BAM_MITOCH = """
  {{
    "bam_merged": {{
      "location": "{raw_data}/{uid}/{uid}.bam",
      "class": "File"
    }}
  }}
"""

MODEL_R = """
  {{
    "macs2_moder_r": {{
      "location": "{raw_data}/{uid}/{uid}_macs_model.r",
      "class": "File"
    }}
  }}
"""


"""
+----+---------------------------------+----------------------------------+
| id | etype                           | workflow                         |
+----+---------------------------------+----------------------------------+
|  1 | DNA-Seq                         | chipseq-se.cwl                   |
|  2 | DNA-Seq pair                    | chipseq-pe.cwl                   |
|  3 | RNA-Seq                         | rnaseq-se.cwl                    |
|  4 | RNA-Seq pair                    | rnaseq-pe.cwl                    |
|  5 | RNA-Seq dUTP                    | rnaseq-se-dutp.cwl               |
|  6 | RNA-Seq dUTP pair               | rnaseq-pe-dutp.cwl               |
|  7 | RNA-Seq dUTP Mitochondrial      | rnaseq-se-dutp-mitochondrial.cwl |
|  8 | DNA-Seq Trim Galore             | trim-chipseq-se.cwl              |
|  9 | DNA-Seq pair Trim Galore        | trim-chipseq-pe.cwl              |
| 11 | RNA-Seq dUTP pair Mitochondrial | rnaseq-pe-dutp-mitochondrial.cwl |
+----+---------------------------------+----------------------------------+
"""


OUTPUT_TEMPLATES = {
    1: {
        "narrow": [COMMON, CHIP, BAM,             BIGWIG,              SE,     NARROW,        MODEL_R,          ADD_FIELDS],
        "broad":  [COMMON, CHIP, BAM,             BIGWIG,              SE,             BROAD, MODEL_R,          ADD_FIELDS]
    },
    2: {
        "narrow": [COMMON, CHIP, BAM,             BIGWIG,                  PE, NARROW,                          ADD_FIELDS],
        "broad":  [COMMON, CHIP, BAM,             BIGWIG,                  PE,         BROAD,                   ADD_FIELDS]
    },
    8: {
        "narrow": [COMMON, CHIP, BAM,             BIGWIG,              SE,     NARROW,        MODEL_R, TRIM_SE, ADD_FIELDS],
        "broad":  [COMMON, CHIP, BAM,             BIGWIG,              SE,             BROAD, MODEL_R, TRIM_SE, ADD_FIELDS]
    },
    9: {
        "narrow": [COMMON, CHIP, BAM,             BIGWIG,                  PE, NARROW,                 TRIM_PE, ADD_FIELDS],
        "broad":  [COMMON, CHIP, BAM,             BIGWIG,                  PE,         BROAD,          TRIM_PE, ADD_FIELDS]
    },
    3: {
        "narrow": [COMMON, RNA,  BAM,             BIGWIG,              SE,                                      ADD_FIELDS]
    },
    4: {
        "narrow": [COMMON, RNA,  BAM,             BIGWIG,                  PE,                                  ADD_FIELDS]
    },
    5: {
        "narrow": [COMMON, RNA,  BAM,                     BIGWIG_DUTP, SE,                                      ADD_FIELDS]
    },
    6: {
        "narrow": [COMMON, RNA,  BAM,                     BIGWIG_DUTP,     PE,                                  ADD_FIELDS]
    },
    7: {
        "narrow": [COMMON, RNA,       BAM_MITOCH,         BIGWIG_DUTP, SE,                                      ADD_FIELDS]
    },
    11: {
        "narrow": [COMMON, RNA,       BAM_MITOCH,         BIGWIG_DUTP,     PE,                                  ADD_FIELDS]
    }
}
