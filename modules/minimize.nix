{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  boot.initrd.compressor = "zstd"; # Better compression than gzip

  systemd.services.systemd-resolved.enable = false; # if you don't need it
  systemd.services.systemd-timesyncd.enable = false; # if you don't need NTP
  services.udisks2.enable = false;

  system.switch.enable = false;
  nix.enable = false;

  system.etc.overlay.enable = true;
  systemd.sysusers.enable = true;

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;

  system.disableInstallerTools = true;
  programs.less.lessopen = null;
  programs.command-not-found.enable = false;
  boot.enableContainers = false;
  environment.defaultPackages = [ ];
}
