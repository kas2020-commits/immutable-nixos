{
  boot.initrd.compressor = "zstd"; # Better compression than gzip

  systemd.services.systemd-resolved.enable = false; # if you don't need it
  systemd.services.systemd-timesyncd.enable = false; # if you don't need NTP

  system.etc.overlay.enable = true;
  system.etc.overlay.mutable = false;

  # https://www.freedesktop.org/software/systemd/man/latest/machine-id.html#First%20Boot%20Semantics
  environment.etc."machine-id".text = "";

  systemd.sysusers.enable = true;

  system.disableInstallerTools = true;
  programs.less.lessopen = null;
  boot.enableContainers = false;
  environment.defaultPackages = [ ];
}
