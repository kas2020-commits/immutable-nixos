{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
let
  efiArch = pkgs.stdenv.hostPlatform.efiArch;
in
{

  imports = [
    "${modulesPath}/image/repart.nix"
  ];

  image.repart = {
    name = config.boot.uki.name;
    partitions = {
      ESP = {
        contents = {
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
            "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

          "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
            "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
        };
        repartConfig = {
          Type = "esp";
          Label = "esp";
          Format = "vfat";
          SizeMinBytes = "256M";
        };
      };
      store = {
        storePaths = [ config.system.build.toplevel ];
        nixStorePrefix = "/";
        repartConfig = {
          Type = "linux-generic";
          Label = "store";
          Format = "squashfs";
          MakefsOptions = [
            "-comp"
            "zstd"
            "-Xcompression-level"
            "19"
          ];
          Minimize = "best";
          ReadOnly = "yes";
          SizeMinBytes = "1G";
          SizeMaxBytes = "1G";
        };
      };
    };
  };
}
