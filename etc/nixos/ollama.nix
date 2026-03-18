{ config, pkgs, lib, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu; # pkgs.ollama[,-vulkan,-rocm,-cuda,-cpu]
    loadModels = [
      "codellama:7b-instruct"
      "llama3.1:latest"
    ];
  };

}

