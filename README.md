# BioWardrobe Airflow Plugins


1. Add new pool for plugins, update `create_biowardrobe_plugin` function with the correct
pool name
2. Update `group_concat_max_len` on DB configuration, if concatenated text is trancated
3. Apply scripts from `biowardrobe_views` if needed
4. DAG example
```buildoutcfg
#!/usr/bin/env python3
from airflow import DAG
from biowardrobe_airflow_plugins import biowardrobe_plugin
dag = biowardrobe_plugin("super-enhancer.cwl")
```
