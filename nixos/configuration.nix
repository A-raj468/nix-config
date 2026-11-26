{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "maxi";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    curl
    wget
    openssh
    rsync
    netcat-gnu

    unzip
    zip
    xz

    vim
    less

    gnumake
    jq
    file
    tree

    htop
    lsof
    strace
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  programs.zsh.enable = true;

  users.users.maxi.shell = pkgs.zsh;

  system.stateVersion = "26.05";
}
