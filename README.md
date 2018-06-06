# BioWardrobe Airflow Plugins

1. Install **biowardrobe-airflow-plugins** from PyPi

```
    pip3 install biowardrobe-airflow-plugins
```

2. Run **biowardrobe-plugin-init** in any folder
```
    biowardrobe-plugin-init
```

To trigger all available plugins by experiment UID
```bash
    airflow trigger_dag --conf "{\"uid\":\"UID\"}" biowardrobe_plugins
```

To trigger the specific plugin by experiment UID
```bash
    airflow trigger_dag --conf "{\"uid\":\"UID\"}" <plugin's name>
```
