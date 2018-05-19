# BioWardrobe Airflow Plugins

1. Install **biowardrobe-airflow-plugins** from PyPi

```
    pip3 install biowardrobe-airflow-plugins
```

2. Run **biowardrobe-plugin-init** in any folder to execute SQL patches
**experimentype2plugintype_view.sql** and **plugintype_patch.sql**
```
    biowardrobe-plugin-init
```
3. Add new pool **biowardrobe_plugins** into Airflow
4. Set **group_concat_max_len** value from DB configuration to 1048576 (1M).
5. Make sure that **biowardrobe-cwl-workflows** includes **super-enhancer.cwl** workflow
6. To display bigBed Super Enhancers tracks, apply SQL patches from **biowardrobe_views** if needed

DAG example
```buildoutcfg
#!/usr/bin/env python3
from airflow import DAG
from biowardrobe_airflow_plugins import biowardrobe_plugin
dag = biowardrobe_plugin("super-enhancer.cwl")
```
