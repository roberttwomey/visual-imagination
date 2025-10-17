# visual-imagination

Working with Text -> Image Networks, exploring Artificial Visual Imagination.
Open AI CLIP
BigGAN

## Notebooks

- [pom_synthesis.ipynb](pom_synthesis.ipynb) POM Berlin 2021 run on Z8 
- [hcc_synthesis.ipynb](hcc_synthesis.ipynb) runs on HCC OOD

## OOD Kernel Setup for CLIP+BigGAN

```
module purge
module load mamba tensorflow-gpu/py38/2.3
mamba create --clone $CONDA_DEFAULT_ENV -p /work/emar349/shared/envs/torch-gpu-clip
module unload tensorflow-gpu/py38/2.3
conda activate /work/emar349/shared/envs/torch-gpu-clip
mamba install pytorch torchvision -c pytorch
mamba install ftfy regex tqdm git nltk cma pytorch-pretrained-biggan imageio
pip install git+https://github.com/openai/CLIP.git
python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
cp -r ~/.local/share/jupyter/kernels/torch-gpu-clip /home/emar349/shared/jupyter/kernels
```

## Docker Setup

### Build the Docker image
```bash
docker build -t visual-imagination .
```

### Run with GPU support
```bash
docker run --gpus all -p 8888:8888 -v $(pwd):/app visual-imagination
```

### Access Jupyter Notebook
Once the container is running, open your browser and go to:
- http://localhost:8888
- Use the token provided in the terminal output to access Jupyter

The Docker container includes:
- Python 3.8
- TensorFlow GPU 2.3
- PyTorch with CUDA support
- CLIP from OpenAI
- All required dependencies for CLIP+BigGAN

