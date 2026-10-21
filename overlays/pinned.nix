# packages that have to be built from source (cuda, etc) are taken from a
# separately pinned nixpkgs so `nix flake update` doesn't cause a long
# rebuild. everything else still tracks unstable
# see zsh alias flakeup-pinned
{nixpkgs-pinned}: final: prev: let
  # cudaSupport is set for this whole package set (not via .override) so the
  # derivations matches cache.nixos-cuda.org builds 
  pinned = import nixpkgs-pinned {
    inherit (prev.stdenv.hostPlatform) system;
    config = {
      allowUnfree = true; # cuda is unfree
      cudaSupport = true;
    };
  };
in {
  llama-cpp-cuda = pinned.llama-cpp;
  blender-cuda = pinned.blender;
}
