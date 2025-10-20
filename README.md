# Immutable NixOS Disk Image

Inspired by blit'z [sysupdate playground](https://github.com/blitz/sysupdate-playground.git) repo, this flake is a proof-of-concept for creating hermetic, immutable disk images built using nix. Namely, this flake ensures that this not only works inside qemu but also booting from a usb device.

Since we're using [systemd-repart](https://www.freedesktop.org/software/systemd/man/latest/systemd-repart.html) for disk partitioning (rather than disko) we incur any limitations of the system. Namely, we have to pave an entire (singular) disk for this to work. That shouldn't be a big deal for this use case however.

## Running on QEMU

You can use the included qemu wrapper (provided through `nix shell`) to easily run the resultant qcow2 disk image after building it:

```
nix build .#qemu
qemu-efi-helper result/immutable_25.11.qcow2
```

## Running on bare metal

If you instead want to install on bare metal, build the `live` package instead and 

```
nix build .#live
sudo dd if=$(realpath result/immutable_25.11.raw) of=/path/to/your/disk bs=4M status=progress conv=fsync
```

## Acknowledgements

Big shout out to Julian for his example github repo and associated [blog post](https://x86.lol/generic/2024/08/28/systemd-sysupdate.html). Please do give it a read!
