# BioWardrobe Airflow Plugins

1. Install **biowardrobe-airflow-plugins** from PyPi

```
    pip3 install biowardrobe-airflow-plugins
```

2. Run **biowardrobe-plugin-init** in any folder to apply SQL patches
**experimentype2plugintype_view.sql** and **plugintype_patch.sql**
```
    biowardrobe-plugin-init
```
3. Add new pool **biowardrobe_plugins** into Airflow
4. Set **group_concat_max_len** value from DB configuration to 1048576 (1M).
5. Update **biowardrobe-cwl-workflows** to include the latest **super-enhancer.cwl** workflow
6. Apply SQL patches from **biowardrobe_views** to display bigBed Super Enhancers tracks
7. Create DAG for **super-enhancer** plugin workflow
```bash
    #!/usr/bin/env python3
    from airflow import DAG
    from biowardrobe_airflow_plugins import biowardrobe_plugin
    dag = biowardrobe_plugin("super-enhancer.cwl")
```

To fetch the list of available plugins by UID
```sql
  SELECT p.etype 
  FROM labdata l
  LEFT JOIN experimenttype2plugintype m ON m.experimenttype_id=l.experimenttype_id
  LEFT JOIN plugintype p ON p.id=m.plugintype_id
  WHERE uid='uid'
```
To trigger plugin by name and experiment UID
```bash
    airflow trigger_dag --conf "{\"biowardrobe_uid\":\"UID\"}" super-enhancer
```