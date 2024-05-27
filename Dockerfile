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
RUN CUDACXX=/usr/local/cuda-12/bin/nvcc CMAKE_ARGS="-DLLAMA_CUBLAS=on -DCMAKE_CUDA_ARCHITECTURES=all-major" FORCE_CMAKE=1 \
    pip install -r /workspace/requirements.txt --no-cache-dir --force-reinstall --upgrade

WORKDIR /workspace

# Copy over my notebooks
COPY notebooks /workspace/notebooks

# Copy the GPU test script to the container
COPY scripts/test_gpu.py /workspace/scripts/test_gpu.py

# Copy the entrypoint script to the container
COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

# Run the entrypoint script on container startup
ENTRYPOINT ["/workspace/entrypoint.sh"]
