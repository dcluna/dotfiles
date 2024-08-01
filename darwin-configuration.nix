{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # taken from https://github.com/LnL7/nix-darwin/issues/339
  system.activationScripts.preActivation = {
    enable = true;
    text = ''
      if [ ! -d "/var/lib/postgresql/" ]; then
        echo "creating PostgreSQL data directory..."
        sudo mkdir -m 750 -p /var/lib/postgresql/
        chown -R danielluna:staff /var/lib/postgresql/
      fi
    '';
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    extraPlugins = with pkgs.postgresql_15.pkgs; [ postgis h3-pg pgvector ];
    initdbArgs = ["-U danielluna" "--pgdata=/var/lib/postgresql/15" "--no-locale" "--encoding=UTF8"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method optional_ident_map
      local all       all     peer        map=superuser_map
      #type database  user    address   method
      host  all       all     localhost trust
    '';
    identMap = ''
       # ArbitraryMapName systemUser  DBUser
       superuser_map      root        postgres
       superuser_map      postgres    postgres
       superuser_map      danielluna  postgres
       # Let other names login as themselves
       superuser_map      /^(.*)$     \1
    '';
    settings = {
      track_io_timing = true;
    };
    # ensureDatabases = [ "postgres" ]; # doesnt work on nix-darwin
    # initialScript = pkgs.writeText "backend-initScript" '' # doesnt work on nix-darwin
    #   CREATE ROLE postgres CREATEDB;
    #   CREATE DATABASE postgres;
    #   GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;
    # '';
  };

  launchd.user.agents.postgresql.serviceConfig = {
    StandardErrorPath = "/Users/danielluna/nix-postgres/postgres.error.log";
    StandardOutPath = "/Users/danielluna/nix-postgres/postgres.log";
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
