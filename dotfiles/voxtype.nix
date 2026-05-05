{ pkgs, ... }:
{
  services.voxtype = {
    enable = true;
    package = pkgs.voxtype-vulkan;
    wayland.display = "wayland-1";
    loadModels = [ "base.en" ];
    settings = {
      whisper = {
        model = "base.en";
        language = "en";
      };
      output = {
        mode = "type";
        fallback_to_clipboard = true;
      };
    };
  };
}
