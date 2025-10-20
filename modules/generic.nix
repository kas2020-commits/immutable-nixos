{ lib, ... }:
{
  boot.loader = {
    grub.enable = false;
    timeout = 0;
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };
  };

  systemd.settings.Manager = {
    KExecWatchdogSec = "5min";
    RebootWatchdogSec = "10min";
    RuntimeWatchdogSec = "30s";
    WatchdogDevice = "/dev/watchdog";
  };

  users.users.root.initialPassword = "password";

  powerManagement.enable = false;

  users.mutableUsers = false;
  services.getty.autologinUser = "root";
  boot.initrd.systemd.enable = true;
  boot.initrd.checkJournalingFS = false; # squashfs doesn't need this

  # Since this is immutable, the stateVersion is whatever version was used
  # during build time.
  boot.uki.name = "immutable";
  system.nixos.distroId = "immutable-nixos";
  system.nixos.distroName = "ImmutableNixOS";
  system.image.version = lib.trivial.release;
  system.stateVersion = lib.trivial.release;
}
