{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  buildInputs = with pkgs; [
    (callPackage ./bwfmetaedit.nix {})
    powershell
  ];
}
