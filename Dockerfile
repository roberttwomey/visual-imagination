# Dockerfile for CLIP+BigGAN visual imagination environment
# Based on OOD Kernel Setup instructions
# Optimized for Jetson Orin Nano (ARM64 architecture)

FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DEFAULT_ENV=torch-gpu-clip
ENV PATH=/opt/conda/bin:$PATH

# Set working directory
WORKDIR /app

# Copy notebooks and project files
COPY *.ipynb /app/
COPY README.md /app/

# Fix GPG key issues and install additional system dependencies
RUN apt-key adv --fetch-keys https://repo.download.nvidia.com/jetson/jetson-ota-public.asc && \
    apt-get update && \
    apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install TensorFlow (L4T image comes with PyTorch pre-installed)
RUN pip install tensorflow==2.13.0

# Install additional required packages
RUN pip install ftfy regex tqdm nltk cma pytorch-pretrained-biggan imageio

# Install CLIP from GitHub
RUN pip install git+https://github.com/openai/CLIP.git

# Install Jupyter and ipykernel
RUN pip install jupyter ipykernel && \
    python -m ipykernel install --user --name l4t-pytorch --display-name "Python (L4T PyTorch)"

# Create a startup script
RUN echo '#!/bin/bash\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Expose Jupyter port
EXPOSE 8888

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
