{ pkgs, ... }:
{
  services.comfyui = {
    enable = true;
    gpuSupport = "cuda"; # Enable NVIDIA GPU acceleration (recommended for most users)
    # gpuSupport = "rocm";  # Enable AMD GPU acceleration
    # cudaCapabilities = [ "8.9" ];  # Optional: optimize system CUDA packages for RTX 40xx
    #   Note: Pre-built PyTorch wheels already support all GPU architectures
    enableManager = true; # Enable the built-in ComfyUI Manager
    port = 8188;
    listenAddress = "0.0.0.0"; # Use "0.0.0.0" for network access
    openFirewall = true;
    #customNodes = {
    #  ComfyUI-SeedVR2_VideoUpscaler = pkgs.fetchFromGitHub {
    #    owner = "numz";
    #    repo = "ComfyUI-SeedVR2_VideoUpscaler";
    #    rev = "4490bd1f482e026674543386bb2a4d176da245b90";
    #    hash = "sha256-6nsqFflLw9vYH/du35ET46fdAm1NMjjTe2bA8JmaBE4="; };
    #};
    # extraArgs = [ "--lowvram" ];
    # environment = { };
  };
}
