FROM continuumio/anaconda3
ARG PY=3.9
RUN conda install -c conda-forge jupyterhub mlflow -y
COPY config.py /etc/config.py
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

COPY kernel.json /opt/conda/share/jupyter/kernels/python3/kernel.json
EXPOSE 8888
CMD ['sh','/etc/entrypoint.sh']


