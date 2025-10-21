{ modulesPath, ... }:
{
  imports = [
    ./minimize.nix
    ./generic.nix
    ./filesystems.nix
    ./repart.nix

    # Profile specifically designed for this use-case. It disables things that
    # are enabled by default like nix, system.switch etc...
    # NOTE: DO NOT REMOVE
    "${modulesPath}/profiles/image-based-appliance.nix"

    # # Experimental profile with basic hardening features.
    # "${modulesPath}/profiles/hardened.nix"
  ];
}
