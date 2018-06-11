# Super Enhancer
INSERT IGNORE INTO `ems`.`plugintype` SELECT NULL, 'Super Enhancer', '', '', '','';
UPDATE `ems`.`plugintype` SET
  workflow='super-enhancer.cwl',
  template='{{
    "islands_file": {{"class": "File", "location": "{outputs[macs2_called_peaks][location]}", "format": "http://edamontology.org/format_3468"}},
    "islands_control_file": {{"class": "File", "location": "{raw_data}/{control_uid}/{control_uid}_macs_peaks.xls", "format": "http://edamontology.org/format_3468"}},
    "bambai_pair": {{"class": "File", "location": "{outputs[bambai_pair][location]}", "format": "http://edamontology.org/format_2572"}},
    "annotation_file": {{"class": "File", "location": "{indices}/annotations/{genome_type}/refgene.tsv", "format": "http://edamontology.org/format_3475"}},
    "chrom_length_file": {{"class": "File", "location": "{indices}/STAR/{genome_type}/chrNameLength.txt", "format": "http://edamontology.org/format_2330"}},
    "stitch_distance": 20000,
    "tss_distance": 2500,
    "promoter_bp": {outputs[promoter]},
    "output_folder": "{raw_data}/{uid}",
    "uid": "{uid}"
  }}',
  upload_rules='{{
      "upload_bigbed": "{uid}_super_enhancer.bb"
  }}',
  etype_id='[1,2,8,9]'
WHERE ptype='Super Enhancer';

# Plot RNA-Seq
INSERT IGNORE INTO `ems`.`plugintype` SELECT NULL, 'Plot RNA-Seq', '', '', '','';
UPDATE `ems`.`plugintype` SET
  workflow='plot-rna.cwl',
  template='{{
    "annotation_file": {{"class": "File", "location": "{indices}/annotations/{genome_type}/refgene.tsv"}},
    "bambai_pair": {{"class": "File", "location": "{outputs[bambai_pair][location]}"}},
    "isoforms_file": {{"class": "File", "location": "{outputs[rpkm_isoforms][location]}"}},
    "stats_file": {{"class": "File", "location": "{outputs[get_stat_log][location]}"}},
    "pair": "{pair}",
    "dutp": "{dutp}",
    "threads": {threads},
    "output_folder": "{raw_data}/{uid}",
    "uid": "{uid}"
  }}',
  upload_rules='{{}}',
  etype_id='[3,4,5,6]'
WHERE ptype='Plot RNA-Seq';
