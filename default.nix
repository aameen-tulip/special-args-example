{ nixpkgs ? builtins.getFlake "nixpkgs"
, lib     ? nixpkgs.lib
, system  ? builtins.currentSystem
, pkgsFor ? nixpkgs.legacyPackages.${system}
}: let
  text = ( lib.evalModules {
    modules     = [./mod-a.nix];
    specialArgs = {
      foo = "hi";
      bar = "there";
    };
  } ).config.dumpSpecial + "\n";
in derivation {
  inherit system text;
  name       = "dump-text";
  builder    = "${pkgsFor.bash}/bin/bash";
  passAsFile = ["text"];
  args       = ["-eu" "-o" "pipefail" "-c" ''
    while IFS= read -r line; do
      printf '%s\n' "$line" >> "$out";
    done <"$textPath"
  ''];
  preferLocalBuild = true;
  allowSubstitutes = ( builtins.currentSystem or "unknown" ) != system;
}
