# BioWardrobe Airflow Plugins

1. Install **biowardrobe-airflow-plugins** from PyPi

```
    pip3 install biowardrobe-airflow-plugins
```

2. Run **biowardrobe-plugin-init** in any folder
```
    biowardrobe-plugin-init
```

To trigger plugin by name and experiment UID
```bash
    airflow trigger_dag --conf "{\"uid\":\"UID\"}" super-enhancer
```

When experiment is restarted drop Super Enhancer bigBed track from corresponded to UID
genome database
```python
    "{}_senhncr_f_wtrack".format(UID.replace("-", "_"))
```

