# Placeholder — replace with the actual hardware-configuration.nix
# generated on your OCI instance after installing NixOS.
#
# Generate it by running on the OCI instance:
#   nixos-generate-config --show-hardware-config
#
# OCI Ampere A1 typically needs:
#   - virtio disk/net modules
#   - EFI boot
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "virtio_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [];
}
