{ pkgs, ... }:
{
  imports = [
    ./user.nix
    ./ssh.nix
  ];

  time.timeZone = "Asia/Tokyo";

  environment.packages = with pkgs; [
    atool
    eza
    ffmpeg
    gdb
    killall
    lsof
    neofetch
    neovim
    p7zip
    pciutils
    #rar
    socat
    sops
    unzip
    wget
    xdg-utils
    zip
    gnused
    gnutar
    openssh
    unzip
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "23.11";
}
