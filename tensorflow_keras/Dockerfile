# NVIDIA-GPU
FROM nvidia/cuda:8.0-cudnn6-runtime-ubuntu16.04
LABEL maintainer “NVIDIA CORPORATION <cudatools@nvidia.com>”

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    gcc \
    zlib1g-dev \
    openssl \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libmecab-dev \
    libblas-dev \
	liblapack-dev\
    libatlas-base-dev \
    mecab \
    mecab-naist-utf8 \
    libmecab-dev \
	gfortran \
    libav-tools \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# pip install
COPY requirements.txt /tmp
RUN pip3.6 install -r /tmp/requirements.txt
RUN python3.6 --version
RUN python -m ipykernel.kernelspec

COPY . /usr/src/app


# Set up Jupyter Notebook config
ENV CONFIG /root/.jupyter/jupyter_notebook_config.py
ENV CONFIG_IPYTHON /root/.ipython/profile_default/ipython_config.py 

RUN jupyter notebook --generate-config --allow-root && \
    ipython profile create

RUN echo "c.NotebookApp.ip = '*'" >>${CONFIG} && \
    echo "c.NotebookApp.open_browser = False" >>${CONFIG} && \
    echo "c.NotebookApp.iopub_data_rate_limit=10000000000" >>${CONFIG} && \
    echo "c.MultiKernelManager.default_kernel_name = 'python3'" >>${CONFIG} 

RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >>${CONFIG_IPYTHON} 

# port
EXPOSE 8888 6006 

VOLUME /notebooks

# Run Jupyter Notebook
WORKDIR "/notebooks"
CMD ["jupyter","notebook", "--allow-root"]
