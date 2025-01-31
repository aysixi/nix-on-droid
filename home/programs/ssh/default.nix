{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host nixos
        Hostname 10.0.0.198
        Port 25566
        User mafuyu
        IdentityFile ~/.ssh/nixos
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        IdentityFile ~/.ssh/github
      Host openwrt
        Hostname 10.0.0.1
        Port 22
        User root
        IdentityFile ~/.ssh/openwrt
      Host vps.r
        Hostname nadeko.top
        Port 22122
        User root
        IdentityFile ~/.ssh/vps
      Host vps.n
        Hostname nadeko.top
        Port 22122
        User nadeko
        IdentityFile ~/.ssh/vps
    '';
  };
  services.ssh-agent.enable = true;
}
