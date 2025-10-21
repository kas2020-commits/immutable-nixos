{
  boot.kernelParams = [ "console=tty0" ];
  boot.initrd.availableKernelModules = [
    "usb_storage"
    "uas"
  ];
}
