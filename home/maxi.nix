
{ config, pkgs, ... }:

{
  home.username = "maxi";
  home.homeDirectory = "/home/maxi";

  home.stateVersion = "26.05";

  programs.git = {
    enable = true;

    settings = {
      user.name = "Aditya Raj";
      user.email = "adityaraj6508@gmail.com";
    };
  };

  programs.home-manager.enable = true;
}
