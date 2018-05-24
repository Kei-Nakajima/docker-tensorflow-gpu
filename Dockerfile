# TensorFlow & scikit-learn with Python3.6
FROM python:3.6
LABEL maintainer “Kei Nakajima<keisuke.nakajima.phys@gmail.com>”

# Install dependencies
RUN apt-get update && apt-get install -y \
    libblas-dev \
	liblapack-dev\
    libatlas-base-dev \
    mecab \
    mecab-naist-jdic \
    libmecab-dev \
	gfortran \
    libav-tools \
    python3-setuptools

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA GPU
ARG repository
FROM ${repository}:9.0-runtime-ubuntu16.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV CUDNN_VERSION 7.1.2.21
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*

# Install TensorFlow GPU version
ENV TENSORFLOW_VERSION 1.8.0
RUN pip3 --no-cache-dir install \
    https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${TENSORFLOW_VERSION}-cp36-cp36m-linux_x86_64.whl

# Install Python library for Data Science
RUN pip3 --no-cache-dir install \
        keras \
        sklearn \
        jupyter \
        ipykernel \
		scipy \
        simpy \
        matplotlib \
        numpy \
        pandas \
        plotly \
        sympy \
        mecab-python3 \
        librosa \
        Pillow \
        h5py \
        google-api-python-client \
        && \
    python -m ipykernel.kernelspec

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

# Copy sample notebooks.
COPY notebooks /notebooks

# port
EXPOSE 8888 6006 

VOLUME /notebooks

# Run Jupyter Notebook
WORKDIR "/notebooks"
CMD ["jupyter","notebook", "--allow-root"]

