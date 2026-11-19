{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "maxi";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  system.stateVersion = "26.05";
}
