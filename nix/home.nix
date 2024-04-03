{ config, pkgs, ... }:

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
  ];

  home.file = {
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
}
