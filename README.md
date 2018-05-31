# BioWardrobe Airflow Plugins

1. Install **biowardrobe-airflow-plugins** from PyPi

```
    pip3 install biowardrobe-airflow-plugins
```

2. Run **biowardrobe-plugin-init** in any folder
```
    biowardrobe-plugin-init
```

To trigger plugin by name for the specific experiment UID
```bash
    airflow trigger_dag --conf "{\"uid\":\"UID\"}" super-enhancer
```
