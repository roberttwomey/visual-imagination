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
module load mamba tensorflow-gpu/py39/2.7
mamba create --clone $CONDA_DEFAULT_ENV -p /work/emar349/shared/envs/torch-gpu-clip
module unload tensorflow-gpu/py39/2.7
conda activate /work/emar349/shared/envs/torch-gpu-clip
mamba install pytorch torchvision -c pytorch
mamba install ftfy regex tqdm
pip install git+https://github.com/openai/CLIP.git
python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
cp -r ~/.local/share/jupyter/kernels/torch-gpu-clip /home/emar349/shared/jupyter/kernels
```

