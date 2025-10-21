# Immutable NixOS Disk Image

This repo is a proof-of-concept attempt of building an immutable "golden" image using NixOS instead of `mkosi`.

> But What **is** a "golden" image, anyways?

You should read systemd's article on [Building Images Safely](https://systemd.io/BUILDING_IMAGES/) for more context, but the general idea is to create a single disk image that you will flash onto some fleet of computers and have each one just work™ all with proper initialization, unique machine IDs, vendored binaries/runtimes and more.

We're adding additional contraints to the golden image concept here by making the entire drive as immutable as humanly possible. This is achieved by mounting a tmpfs on root and really only providing `/nix/store` and letting systemd fill out the rest. NixOS takes care of a special overlayfs for `/etc` and getting the stuff in the nix store mounted proper where needed.

## Running on QEMU

You can use the included qemu wrapper (provided through `nix shell`) to easily run the resultant qcow2 disk image after building it:

```
nix build .#qemu
qemu-efi-helper result/immutos_25.11.qcow2
```

## Booting From a USB Storage Device

The second currently exposed option is to flash the disk image onto a device that will be booted from via usb on the desired machine.

> Of course, there's no reason you can't use this same image to flash an internal ssd, but I digress

Simply build the `usb` package and flash it onto the usb device (be sure to change the `of=` path in the cmdline!):

```
nix build .#usb
sudo dd if=$(realpath result/immutos_25.11.raw) of=/path/to/your/disk bs=4M status=progress conv=fsync
```

## Acknowledgements

Big shout out to Julian for his example github repo and associated [blog post](https://x86.lol/generic/2024/08/28/systemd-sysupdate.html). Please do give it a read! It's where I found some of the critical ideas like using the new `image.repart` module in NixOS.


## Some Ideas For Future Work

- Try out the [tpm2-totp](https://nixos.org/manual/nixos/unstable/#module-boot-plymouth-tpm2-totp) feature and add it as an (optional) module. But figure out if anything special is required for the immutable/forgetful nature of this build. 
