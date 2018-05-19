DROP VIEW IF EXISTS `ems`.`experimenttype2plugintype`;
CREATE VIEW `ems`.`experimenttype2plugintype` AS

# Assign Super Enhancer plugin to DNA-Seq experiment
SELECT
    `e`.`id` AS `experimenttype_id`,
    `p`.`id` AS `plugintype_id`
FROM  ((`ems`.`experimenttype` `e` JOIN `ems`.`plugintype` `p`))
WHERE ((`e`.`etype`='DNA-Seq') AND (`p`.`etype`='Super Enhancer'))