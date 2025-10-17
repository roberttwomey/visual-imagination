# Dockerfile for CLIP+BigGAN visual imagination environment
# Based on OOD Kernel Setup instructions

FROM nvidia/cuda:11.8-cudnn8-devel-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DEFAULT_ENV=torch-gpu-clip
ENV PATH=/opt/conda/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda with Python 3.8
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Initialize conda and install mamba
RUN conda init bash && \
    conda install mamba -n base -c conda-forge -y

# Set working directory
WORKDIR /app

# Copy notebooks and project files
COPY *.ipynb /app/
COPY README.md /app/

# Install TensorFlow GPU 2.3 with Python 3.8
RUN conda create -n base python=3.8 -y && \
    conda activate base && \
    pip install tensorflow-gpu==2.3.0

# Create the torch-gpu-clip environment (equivalent to mamba create --clone)
RUN conda create -n torch-gpu-clip python=3.8 -y

# Activate the environment and install packages
RUN conda activate torch-gpu-clip && \
    conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
    conda install -c conda-forge ftfy regex tqdm git nltk cma imageio -y && \
    pip install pytorch-pretrained-biggan

# Install CLIP from GitHub
RUN conda activate torch-gpu-clip && \
    pip install git+https://github.com/openai/CLIP.git

# Install Jupyter and ipykernel
RUN conda activate torch-gpu-clip && \
    conda install jupyter ipykernel -c conda-forge -y && \
    python -m ipykernel install --name torch-gpu-clip --display-name "Python (torch-gpu-clip)"

# Set the default conda environment
ENV CONDA_DEFAULT_ENV=torch-gpu-clip

# Create a startup script to activate the environment
RUN echo '#!/bin/bash\n\
source /opt/conda/etc/profile.d/conda.sh\n\
conda activate torch-gpu-clip\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Expose Jupyter port
EXPOSE 8888

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
