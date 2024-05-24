#!/bin/bash

# Default model path
MODEL_PATH=${MODEL_PATH:-"/workspace/models/mixtral-8x7b-instruct-v0.1.Q5_K_M.gguf"}

# Start the llama server
echo "Starting llama server on port 5000 with model $MODEL_PATH"
python -m llama_cpp.server --host 0.0.0.0 --port 5000 --model $MODEL_PATH --n_gpu_layers -1 &

# Start Jupyter Lab
echo "Starting Jupyter Lab on port 8888"
jupyter lab --ip 0.0.0.0 --port 8888 --NotebookApp.token='' --NotebookApp.password='' --no-browser --allow-root

# Keep the script running
wait
