{ config, lib, pkgs, ... }:

let
  extraNodePackages = import ./node/default.nix {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "danielluna";
  home.homeDirectory = "/Users/danielluna";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.zoxide
    pkgs.curlie
    (pkgs.visidata.overrideAttrs(super: rec { propagatedBuildInputs = super.propagatedBuildInputs ++ [pkgs.python3Packages.pyarrow]; }))
    pkgs.xsv
    pkgs.lazydocker
    pkgs.pspg
    pkgs.rufo
    pkgs.lnav
    pkgs.pqrs
    pkgs.wget
    pkgs.gnupg
    pkgs.pgmetrics
    # pkgs.spotify-tui
    pkgs.ledger-autosync
    pkgs.hledger
    pkgs.ledger
    pkgs.asciinema
    # pkgs.csvkit
    pkgs.direnv
    pkgs.htop
    pkgs.httpie
    pkgs.jq
    pkgs.neovim
    pkgs.parallel
    pkgs.pigz
    pkgs.radare2
    pkgs.ripgrep
    pkgs.xsv
    pkgs.k9s
    pkgs.rbspy
    pkgs.stern
    pkgs.llm
    pkgs.semgrep
    pkgs.mcfly
    pkgs.ticker
    pkgs.yamllint
    pkgs.radare2
    pkgs.fx
    pkgs.atuin
    pkgs.asciinema
    pkgs.angle-grinder
    pkgs.lazygit
    pkgs.curl
    pkgs.usql
    pkgs.zoxide
    pkgs.zplug
    pkgs.antigen
    pkgs.octosql
    pkgs.universal-ctags
    pkgs.imgcat
    pkgs.ghq
    pkgs.yq
    pkgs.starship
    pkgs.exercism
    pkgs.jaq
    pkgs.pgsync
    pkgs.heroku
    pkgs.btop
    pkgs.pgformatter
    pkgs.smug
    pkgs.gitu
    pkgs.zellij
    pkgs.prettierd
    pkgs.gnugrep
    pkgs.toxiproxy
    pkgs.trippy
    pkgs.gptcommit
    extraNodePackages.opencommit
  ];

  home.file = {
    "persistent-scratch-backups/.keep".text = "";

    ".tmux.conf.local".source = ~/dotfiles/.tmux.conf.local;

    # ".config/nixpkgs/home.nix".source = ~/dotfiles/nix/home.nix;
    # ".config/home-manager/home.nix".source = $HOME/dotfiles/nix/home.nix;
    ".zshrc".source = ~/dotfiles/.zshrc;
    ".psqlrc".source = ~/dotfiles/.psqlrc;
    ".irbrc".source = ~/dotfiles/.irbrc;
    ".pryrc".source = ~/dotfiles/.pryrc;
    ".railsrc".source = ~/dotfiles/.railsrc;
    ".spacemacs".source = ~/dotfiles/.spacemacs;
    "spacemacs.el".source = ~/dotfiles/spacemacs.el;
    "spacemacs-user-config.el".source = ~/dotfiles/spacemacs-user-config.el;
    ".config/zellij/config.kdl".source = ~/dotfiles/zellij-config.kdl;
    ".config/gptcommit/config.toml".source = ~/dotfiles/gptcommit/config.toml;
    ".bin/gptcommithook".source = ~/dotfiles/gptcommit/gptcommithook;

    ".tmux/plugins/tpm" = {
      source = pkgs.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tpm";
        rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";
        sha256 = "hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
      };
    };
    ".config/toxiproxy.json".source = ~/dotfiles/toxiproxy.json;
    "Projects/AdQuick/.tmuxinator.yml".source = ~/dotfiles/.tmuxinator.adquick.yml;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # TODO: migrate from tpm to zplug
  # programs.zsh = {
  #   zplug = {
  #     enable = true;
  #     plugins = [
  #       { name = "Morantron/tmux-fingers"; } # Simple plugin installation
  #       { name = "tmux-plugins/tmux-logging"; } # Simple plugin installation
  #       { name = "robhurring/tmux-spotify"; } # Simple plugin installation
  #       { name = "schasse/tmux-jump"; } # Simple plugin installation
  #       { name = "dracula/tmux"; } # Simple plugin installation
  #       # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
  #     ];
  #   };
  # };
}
