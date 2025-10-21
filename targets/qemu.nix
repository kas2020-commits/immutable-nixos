{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/image/images.nix"
  ];

  boot.kernelParams = [ "console=ttyS0" ];
}
