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
  } ).config.dumpSpecial;
in derivation {
  inherit system text;
  name       = "dump-text";
  builder    = "${pkgsFor.bash}/bin/bash";
  passAsFile = ["text"];
  PATH       = "${pkgsFor.coreutils}/bin";
  args       = ["-eu" "-o" "pipefail" "-c" ''
    cat "$textPath" > "$out";
  ''];
  preferLocalBuild = true;
  allowSubstitutes = ( builtins.currentSystem or "unknown" ) != system;
}
