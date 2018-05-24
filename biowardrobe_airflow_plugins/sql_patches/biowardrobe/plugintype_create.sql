CREATE TABLE `ems`.`plugintype` (
  `id`           int(11) NOT NULL AUTO_INCREMENT,
  `ptype`        varchar(100) DEFAULT NULL,
  `workflow`     varchar(255) DEFAULT NULL,
  `template`     text DEFAULT NULL,
  `upload_rules` text DEFAULT NULL,
  `etype_id`     varchar(100) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ptype` (`ptype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
