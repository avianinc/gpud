import torch

def test_gpus():
    if not torch.cuda.is_available():
        print("CUDA is not available. Please check your NVIDIA driver and CUDA installation.")
        return False
    
    gpu_count = torch.cuda.device_count()
    print(f"Number of GPUs available: {gpu_count}")
    
    if gpu_count < 1:
        print("No GPUs found. Please ensure your system has at least one GPU.")
        return False

    for i in range(gpu_count):
        device = torch.device(f"cuda:{i}")
        tensor = torch.tensor([1.0, 2.0, 3.0], device=device)
        print(f"GPU {i}: Tensor on device {tensor.device}, values: {tensor}")
    
    print("All GPUs are accessible and operational.")
    return True

if __name__ == "__main__":
    if test_gpus():
        print("GPU test passed.")
    else:
        print("GPU test failed.")
        exit(1)
