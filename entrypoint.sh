#!/bin/sh
sed -i "s|@@@MLFLOW_TRACKING_URI@@@|$MLFLOW_TRACKING_URI|g" /opt/conda/share/jupyter/kernels/python3/kernel.json
sed -i "s|@@@AWS_ACCESS_KEY_ID@@@|$AWS_ACCESS_KEY_ID|g" /opt/conda/share/jupyter/kernels/python3/kernel.json
sed -i "s|@@@AWS_SECRET_ACCESS_KEY@@@|$AWS_SECRET_ACCESS_KEY|g" /opt/conda/share/jupyter/kernels/python3/kernel.json
sed -i "s|@@@MLFLOW_S3_ENDPOINT_URL@@@|$MLFLOW_S3_ENDPOINT_URL|g" /opt/conda/share/jupyter/kernels/python3/kernel.json
sed -i "s|@@@MLFLOW_EXPERIMENT_ID@@@|$MLFLOW_EXPERIMENT_ID|g" /opt/conda/share/jupyter/kernels/python3/kernel.json

jupyterhub -f /etc/config.py