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


CHIPSEQ_COMMON = """
  {{
    "bigwig": {{
      "location": "{raw_data}/{uid}/{uid}.bigWig",
      "class": "File"
    }},
    "bowtie_log": {{
      "location": "{raw_data}/{uid}/{uid}.bw",
      "class": "File"
    }},
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
    "bambai_pair": {{
      "location": "{raw_data}/{uid}/{uid}.bam",
      "class": "File",
      "secondaryFiles": [{{
        "location": "{raw_data}/{uid}/{uid}.bam.bai",
        "class": "File"
      }}]
    }},
    "macs2_called_peaks": {{
      "location": "{raw_data}/{uid}/{uid}_macs_peaks.xls",
      "class": "File"
    }},
    "macs2_moder_r": {{
      "location": "{raw_data}/{uid}/{uid}_macs_model.r",
      "class": "File"
    }},
    "macs2_log": {{
      "location": "{raw_data}/{uid}/{uid}_macs.log",
      "class": "File"
    }},
    "get_stat_log": {{
      "location": "{raw_data}/{uid}/{uid}.stat",
      "class": "File"
    }},
    "macs2_fragment_stat": {{
      "location": "{raw_data}/{uid}/{uid}_fragment_stat.tsv",
      "class": "File"
    }}
  }}
"""

CHIPSEQ_NARROW = """
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

CHIPSEQ_BROAD = """
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

CHIPSEQ_SE = """
  {{
    "fastx_statistics": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }}
  }}
"""

CHIPSEQ_PE = """
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

CHIPSEQ_TRIM_SE = """
  {{
    "trim_report": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }}
  }}
"""

CHIPSEQ_TRIM_PE = """
  {{
    "trim_report_upstream": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }},
    "trim_report_downstream": {{
      "location": "{raw_data}/{uid}/{uid}.fastxstat",
      "class": "File"
    }}
  }}
"""

CHIPSEQ_ADD_FIELDS = """
  {{
    "promoter": {outputs['promoter']}
  }}
"""



# |  1 | DNA-Seq                         |
# |  2 | DNA-Seq pair                    |
# |  8 | DNA-Seq Trim Galore             |
# |  9 | DNA-Seq pair Trim Galore        |



OUTPUT_TEMPLATES = {
    1: {
        "narrow": [CHIPSEQ_COMMON, CHIPSEQ_SE, CHIPSEQ_NARROW, CHIPSEQ_ADD_FIELDS],                  # Checked
        "broad":  [CHIPSEQ_COMMON, CHIPSEQ_SE, CHIPSEQ_BROAD, CHIPSEQ_ADD_FIELDS]                    # Checked
    },
    2: {
        "narrow": [CHIPSEQ_COMMON, CHIPSEQ_PE, CHIPSEQ_NARROW, CHIPSEQ_ADD_FIELDS],
        "broad":  [CHIPSEQ_COMMON, CHIPSEQ_PE, CHIPSEQ_BROAD, CHIPSEQ_ADD_FIELDS]
    },
    8: {
        "narrow": [CHIPSEQ_COMMON, CHIPSEQ_SE, CHIPSEQ_NARROW, CHIPSEQ_TRIM_SE, CHIPSEQ_ADD_FIELDS], # Checked
        "broad":  [CHIPSEQ_COMMON, CHIPSEQ_SE, CHIPSEQ_BROAD,  CHIPSEQ_TRIM_SE, CHIPSEQ_ADD_FIELDS]
    },
    9: {
        "narrow": [CHIPSEQ_COMMON, CHIPSEQ_PE, CHIPSEQ_NARROW, CHIPSEQ_TRIM_PE, CHIPSEQ_ADD_FIELDS],
        "broad":  [CHIPSEQ_COMMON, CHIPSEQ_PE, CHIPSEQ_BROAD,  CHIPSEQ_TRIM_PE, CHIPSEQ_ADD_FIELDS]
    }
}
