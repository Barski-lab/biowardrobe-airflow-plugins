DROP TABLE IF EXISTS `ems`.`plugintype`;
CREATE TABLE `ems`.`plugintype` (
  `id`           int(11) NOT NULL AUTO_INCREMENT,
  `etype`        varchar(100) DEFAULT NULL,
  `workflow`     varchar(255) DEFAULT NULL,
  `template`     text DEFAULT NULL,
  `upload_rules` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `etype` (`etype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# Super Enhancer
INSERT INTO `ems`.`plugintype` SELECT NULL, 'Super Enhancer', '', '', '';
UPDATE `ems`.`plugintype` SET
  workflow='super-enhancer.cwl',
  template='{{
    "islands_file": {{"class": "File", "location": "{params[macs2_called_peaks][location]}", "format": "http://edamontology.org/format_3468"}},
    "islands_control_file": {{"class": "File", "location": "{raw_data}/{control_id}/{control_id}_macs_peaks.xls", "format": "http://edamontology.org/format_3468"}},
    "bambai_pair": {{"class": "File", "location": "{params[bambai_pair][location]}", "format": "http://edamontology.org/format_2572"}},
    "annotation_file": {{"class": "File", "location": "{indices}/annotations/{findex}/refgene.tsv", "format": "http://edamontology.org/format_3475"}},
    "chrom_length_file": {{"class": "File", "location": "{indices}/STAR/{findex}/chrNameLength.txt", "format": "http://edamontology.org/format_2330"}},
    "stitch_distance": 20000,
    "tss_distance": 2500,
    "promoter_bp": {params[promoter]},
    "output_folder": "{raw_data}/{uid}",
    "uid": "{uid}"
  }}',
  upload_rules='{{
      "upload_bigbed": "{}_super_enhancer.bb"
  }}'
WHERE etype='Super Enhancer';