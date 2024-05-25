# LLaMA Model Server with JupyterLab

This project sets up a Docker container to run a LLaMA model server and JupyterLab, utilizing multiple GPUs for enhanced performance. The LLaMA model is kept outside the container for easy management and updating.

## Overview

This tool provides a convenient way to deploy a LLaMA model server alongside JupyterLab in a Docker container. The setup allows for interactive data science and machine learning workflows, leveraging the power of multiple GPUs. Models are stored outside the container, making it easy to manage and switch between different models without rebuilding the Docker image.

## Features

- **LLaMA Model Server**: Hosts large language models accessible via HTTP.
- **JupyterLab**: Provides an interactive environment for data analysis and visualization.
- **Multi-GPU Support**: Leverages multiple GPUs for enhanced performance.
- **External Model Management**: Keeps models outside the container for easy updates.

## Prerequisites

Before starting, ensure you have the following installed on your system:

1. **Docker**: You can install Docker from [here](https://docs.docker.com/get-docker/).
2. **NVIDIA Container Toolkit**: Follow the installation guide [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to set up GPU support in Docker.
3. **A directory with your LLaMA models**: Create a directory on your host machine to store your models, for example: `/host/path/to/models`.

## Setup Instructions

### Step 1: Clone the Repository

Clone this repository to your local machine:

```sh
git clone <repository-url>
cd <repository-directory>
```

### Step 2: Prepare the Models Directory

Ensure you have your LLaMA model files stored in a directory on your host machine, for example: `/host/path/to/models`.

### Step 3: Build the Docker Image

Build the Docker image using the provided `Dockerfile`. This will install all necessary dependencies and set up the environment:

```sh
docker build -t llama-cpp-python:latest .
```

### Step 4: Run the Docker Container

Run the Docker container, mounting the models directory from your host machine and specifying the model path using an environment variable:

```sh
docker run -it --rm -p 8888:8888 -p 5000:5000 --gpus all \
    -v /host/path/to/models:/workspace/models \
    -e MODEL_PATH="/workspace/models/mixtral-8x7b-instruct-v0.1.Q5_K_M.gguf" \
    llama-cpp-python:latest
```

### Step 5: Access the Services

- **JupyterLab**: Open your web browser and navigate to `http://localhost:8888` to access JupyterLab.
- **LLaMA Model Server**: The model server will be accessible at `http://localhost:5000`.

## Project Structure

- **`entrypoint.sh`**: Script to start the LLaMA model server and JupyterLab.
- **`Dockerfile`**: Docker configuration file to set up the container environment.
- **`requirements.txt`**: List of Python packages to install in the container.
- **`.gitignore`**: Specifies files and directories to ignore in version control.

## Notes

- Ensure that your Docker configuration allows for sufficient memory and GPU access.
- You can switch between different models by changing the `MODEL_PATH` environment variable when running the container.

By following these instructions, you can easily set up and run a powerful environment for interactive data science and machine learning workflows using JupyterLab and LLaMA models.
