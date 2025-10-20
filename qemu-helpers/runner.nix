pkgs:
pkgs.writeShellApplication {
  name = "qemu-efi-wrapper";
  runtimeInputs = [ pkgs.qemu ];
  text = ''
    qemu-system-x86_64 \
      -smp 2 -m 2048 -machine q35,accel=kvm \
      -bios "${pkgs.OVMF.fd}/FV/OVMF.fd" \
      -snapshot \
      -serial stdio -hda "$@"
  '';
}
