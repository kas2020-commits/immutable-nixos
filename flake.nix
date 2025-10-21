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
        usb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules
            ./targets/usb.nix
          ];
        };
        qemu = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules
            ./targets/qemu.nix
          ];
        };
      };

      packages.x86_64-linux = rec {
        usb = self.nixosConfigurations.usb.config.system.build.image;
        qemu = qemu-helpers.convert self.nixosConfigurations.qemu.config;
        default = qemu;
      };
    };
}
