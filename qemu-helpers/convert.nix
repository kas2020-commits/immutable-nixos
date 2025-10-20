pkgs: config:
let
  disk_dir = config.system.build.image;
  disk_filename = "${config.boot.uki.name}_${config.system.image.version}";
in
pkgs.runCommand "image"
  {
    nativeBuildInputs = with pkgs; [ qemu ];
  }
  ''
    mkdir -p $out
    qemu-img convert -f raw -O qcow2 \
      -C ${disk_dir}/${disk_filename}.raw \
      $out/${disk_filename}.qcow2
  ''
