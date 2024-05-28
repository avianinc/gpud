#!/bin/bash

# Default model path
MODEL_PATH=${MODEL_PATH:-"/workspace/models/Meta-Llama-3-70B-Instruct.Q5_K_M.gguf"}

# Run the GPU test script
echo "Running GPU test..."
python /workspace/scripts/test_gpu.py

# Check if the GPU test passed
if [ $? -ne 0 ]; then
    echo "GPU test failed. Exiting."
    exit 1
fi

# Start the llama server
echo "Starting llama server on port 5000 with model $MODEL_PATH"
python -m llama_cpp.server --host 0.0.0.0 --port 5000 --model $MODEL_PATH --n_gpu_layers -1 &

# Start Jupyter Lab
echo "Starting Jupyter Lab on port 8888"
jupyter lab --ip 0.0.0.0 --port 8888 --NotebookApp.token='' --NotebookApp.password='' --no-browser --allow-root

# Keep the script running
wait
