{ config, ... }:
let
  Cfg = partition: config.image.repart.partitions.${partition}.repartConfig;
  Label = partition: (Cfg partition).Label;
  Fmt = partition: (Cfg partition).Format;
in
{
  zramSwap.enable = true;
  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [
        "size=25%"
        "mode=0755"
        "noatime"
      ];
    };
    "/boot" = {
      autoResize = false;
      device = "/dev/disk/by-partlabel/${Label "esp"}";
      fsType = Fmt "esp";
      options = [
        "rw"
        "noatime"
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/nix/store" = {
      autoResize = false;
      device = "/dev/disk/by-partlabel/${Label "store"}";
      fsType = Fmt "store";
      options = [ "ro" ];
    };
  };
}
