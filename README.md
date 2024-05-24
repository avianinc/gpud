# LLaMA Model Server with JupyterLab

This project sets up a Docker container to run a LLaMA model server and JupyterLab, utilizing multiple GPUs for enhanced performance. The LLaMA model is kept outside the container for easy management and updating.

## Prerequisites

Before starting, ensure you have the following installed on your system:

1. **Docker**: You can install Docker from [here](https://docs.docker.com/get-docker/).
2. **NVIDIA Container Toolkit**: Follow the installation guide [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to set up GPU support in Docker.
3. **A directory with your LLaMA models**: Create a directory on your host machine to store your models, for example: `/host/path/to/models`.

## Project Structure

```plaintext
project-root/
│
├── entrypoint.sh
├── Dockerfile
├── requirements.txt
├── .gitignore
└── README.md
```

## Setup Instructions

### Step 1: Clone the Repository

Clone this repository to your local machine:

```sh
git clone <repository-url>
cd <repository-directory>
```

### Step 2: Prepare the Models Directory

Ensure you have your LLaMA model files stored in a directory on your host machine, for example: `/host/path/to/models`.

### Step 3: Create or Verify Files

Ensure the following files exist in your project directory with the specified content:

#### `requirements.txt`

```plaintext
jupyterlab
llama-cpp-python[server]
numpy
pandas
matplotlib
seaborn
scikit-learn
scipy
tqdm
ipywidgets
ipykernel
jupyterlab-git
jupyterlab-lsp
python-language-server[all]
tensorflow
torch
torchvision
transformers
datasets
sentence-transformers
notebook
```

#### `entrypoint.sh`

```sh
#!/bin/bash

# Default model path
MODEL_PATH=${MODEL_PATH:-"/workspace/models/mixtral-8x7b-instruct-v0.1.Q5_K_M.gguf"}

# Start the llama server
echo "Starting llama server on port 5000 with model $MODEL_PATH"
python -m llama_cpp.server --host 0.0.0.0 --port 5000 --model $MODEL_PATH &

# Start Jupyter Lab
echo "Starting Jupyter Lab on port 8888"
jupyter lab --ip 0.0.0.0 --port 8888 --NotebookApp.token='' --NotebookApp.password='' --no-browser --allow-root

# Keep the script running
wait
```

Make the script executable:

```sh
chmod +x entrypoint.sh
```

#### `Dockerfile`

```dockerfile
FROM python:3.10-bookworm

# Install CUDA Toolkit (Includes drivers and SDK needed for building llama-cpp-python with CUDA support)
RUN apt-get update && apt-get install -y software-properties-common && \
    wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb && \
    dpkg -i cuda-repo-debian12-12-3-local_12.3.1-545.23.08-1_amd64.deb && \
    cp /var/cuda-repo-debian12-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    add-apt-repository contrib && \
    apt-get update && \
    apt-get -y install cuda-toolkit-12-3 

# Copy the requirements file to the container
COPY requirements.txt /workspace/requirements.txt

# Install the required Python packages
RUN CUDACXX=/usr/local/cuda-12
