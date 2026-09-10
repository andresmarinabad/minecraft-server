{
  description = "Local Minecraft Java server with Bedrock support and Restic backups";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
        f (import nixpkgs { inherit system; }));
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            docker-compose
            restic
            git
            jq
          ];

          shellHook = ''
            export PATH="$PWD/scripts:$PATH"
            echo "Minecraft shell ready: mc-up, mc-down, mc-logs, mc-backup, mc-restore, mc-ip"
          '';
        };
      });
    };
}
