{
  description = "flake for building st";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "st";
        version = "0.9.3";
        src = ./.;



        nativeBuildInputs = with pkgs; [
          pkg-config
          ncurses
          fontconfig
          freetype
        ];
        buildInputs = [
          pkgs.libX11
          pkgs.libxft
        ];

        preInstall = ''
          export TERMINFO=$out/share/terminfo
          mkdir -p $TERMINFO $out/nix-support
          echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
        '';
        installFlags = [ "PREFIX=$(out)" ];

      };
    };
}
