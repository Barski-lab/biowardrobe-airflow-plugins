# BioWardrobe Airflow Plugins
[![Build Status](https://travis-ci.org/Barski-lab/biowardrobe-airflow-plugins.svg?branch=master)](https://travis-ci.org/Barski-lab/biowardrobe-airflow-plugins)

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
