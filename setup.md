generate configuration.nix and hardware-configuration.nix
then move them to wherever and symlink with `sudo ln -s <new-file> <configuration.nix>`

youll probably need to add nixos-unstable as a channel (named `nixos-unstable`) probably as sudo as well.
and possibly also home manager but that one is less likely

