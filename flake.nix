{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        self' = builtins.mapAttrs (n: v: v.${system} or v) self;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            self'.packages.ghokin

            # keep-sorted start
            dprint
            go
            just
            keep-sorted
            pdfpc
            polylux2pdfpc # extract speaker notes
            treefmt
            typst
            typstyle
            # keep-sorted end
          ];
          CGO_ENABLED = "0";
          TYPST_FONT_PATHS = builtins.concatStringsSep ":" [
            # keep-sorted start
            pkgs.fira
            pkgs.font-awesome
            pkgs.noto-fonts
            # keep-sorted end
          ];
        };
        packages.ghokin = pkgs.buildGoModule rec {
          pname = "ghokin";
          version = "3.8.1";
          # https://github.com/antham/ghokin
          src = pkgs.fetchFromGitHub {
            owner = "antham";
            repo = "ghokin";
            rev = "v${version}";
            sha256 = "sha256-tM22eJi5IKlNSP/0oCQAeusfRPKPRlXoo68ZoJ40l0c=";
          };
          vendorHash = "sha256-C9AV97aDlzkTsKrkyfLaGWy9GKZCn6pgDNASBn9igb4=";
        };
      }
    );
}
