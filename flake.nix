{
  description = "An immutable NixOS live disk image";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      qemu-helpers = import ./qemu-helpers nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [ qemu-helpers.runner ];
      };

      nixosConfigurations = {
        live = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules
            {
              boot.kernelParams = [ "console=tty0" ];
              boot.initrd.availableKernelModules = [
                "usb_storage"
                "uas"
              ];
            }
          ];
        };
        qemu = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules
            { boot.kernelParams = [ "console=ttyS0" ]; }
          ];
        };
      };

      packages.x86_64-linux = {
        live = self.nixosConfigurations.live.config.system.build.image;
        qemu = qemu-helpers.convert self.nixosConfigurations.qemu.config;
      };
    };
}
