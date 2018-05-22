DROP VIEW IF EXISTS `ems`.`experimenttype2plugintype`;
CREATE VIEW `ems`.`experimenttype2plugintype` AS

SELECT
    `e`.`id` AS `experimenttype_id`,
    `p`.`id` AS `plugintype_id`
FROM  ((`ems`.`experimenttype` `e` JOIN `ems`.`plugintype` `p`))
WHERE ((`e`.`etype`='DNA-Seq') AND (`p`.`etype`='Super Enhancer'))
UNION
SELECT
    `e`.`id` AS `experimenttype_id`,
    `p`.`id` AS `plugintype_id`
FROM  ((`ems`.`experimenttype` `e` JOIN `ems`.`plugintype` `p`))
WHERE ((`e`.`etype`='DNA-Seq pair') AND (`p`.`etype`='Super Enhancer'))
UNION
SELECT
    `e`.`id` AS `experimenttype_id`,
    `p`.`id` AS `plugintype_id`
FROM  ((`ems`.`experimenttype` `e` JOIN `ems`.`plugintype` `p`))
WHERE ((`e`.`etype`='DNA-Seq Trim Galore') AND (`p`.`etype`='Super Enhancer'))
UNION
SELECT
    `e`.`id` AS `experimenttype_id`,
    `p`.`id` AS `plugintype_id`
FROM  ((`ems`.`experimenttype` `e` JOIN `ems`.`plugintype` `p`))
WHERE ((`e`.`etype`='DNA-Seq pair Trim Galore') AND (`p`.`etype`='Super Enhancer'))