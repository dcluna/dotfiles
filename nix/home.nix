{ config, lib, pkgs, ... }:

let
  extraNodePackages = import ./node/default.nix {};
  claudesquad = pkgs.buildGoModule rec {
    pname = "claude-squad";
    version = "1.0.8";

    src = pkgs.fetchFromGitHub {
      owner = "smtg-ai";
      repo = "claude-squad";
      tag = "v${version}";
      hash = "sha256-mzW9Z+QN4EQ3JLFD3uTDT2/c+ZGLzMqngl3o5TVBZN0=";
    };

    vendorHash = "sha256-BduH6Vu+p5iFe1N5svZRsb9QuFlhf7usBjMsOtRn2nQ=";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "danielluna";
  home.username = "dcluna";
  # home.homeDirectory = "/Users/danielluna";
  home.homeDirectory = "/home/dcluna";

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
    # pkgs.xsv
    pkgs.lazydocker
    pkgs.pspg
    pkgs.rufo
    pkgs.lnav
    pkgs.pqrs
    pkgs.wget
    # pkgs.gnupg
    pkgs.pgmetrics
    # pkgs.spotify-tui
    pkgs.ledger-autosync
    pkgs.hledger
    pkgs.ledger
    pkgs.asciinema
    pkgs.csvkit
    pkgs.direnv
    pkgs.htop
    pkgs.httpie
    pkgs.jq
    pkgs.neovim
    pkgs.parallel
    pkgs.pigz
    pkgs.radare2
    pkgs.ripgrep
    pkgs.xan
    pkgs.k9s
    pkgs.rbspy
    pkgs.stern
    pkgs.llm
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
    pkgs.gitui
    pkgs.zellij
    pkgs.prettierd
    pkgs.gnugrep
    pkgs.toxiproxy
    pkgs.trippy
    pkgs.gptcommit
    extraNodePackages.opencommit
    pkgs.newsboat
    pkgs.pgcenter
    pkgs.awscli2
    pkgs.toot
    pkgs.tmuxinator
    # pkgs.ast-grep
    (pkgs.ffmpeg.override {withWebp = true;})
    (pkgs.imagemagick.override {libwebpSupport = true;})
    pkgs.redis
    pkgs.mise
    pkgs.mitmproxy
    pkgs.entr
    pkgs.bore-cli
    pkgs.rustywind
    pkgs.circleci-cli
    pkgs.git-who
    pkgs.google-cloud-sdk
    # pkgs.wireproxy
    pkgs.gnuplot
    pkgs.watchman
    pkgs.lefthook
    pkgs.just
    pkgs.codex
    pkgs.gh
    # pkgs.opencode
    claudesquad
  ];

  home.file = {
    "persistent-scratch-backups/.keep".text = "";


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
    ".stCommitMsg".text = "";
    ".bashrc.d/mise.sh".source = ~/dotfiles/mise.bash;
    ".bashrc.d/direnv.sh".source = ~/dotfiles/direnv.bash;
    ".bashrc.d/atuin.sh".source = ~/dotfiles/atuin.bash;
    ".bashrc.d/emacs.sh".source = ~/dotfiles/emacs.bash;
    ".opencode.json".source = ~/dotfiles/opencode/opencode.json;
    ".claude-code-router/config.json".source = ~/dotfiles/claudecode/router.json;

    # ".tmux/plugins/tpm" = {
    #   source = pkgs.fetchFromGitHub {
    #     owner = "tmux-plugins";
    #     repo = "tpm";
    #     rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";
    #     sha256 = "hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
    #   };
    # };
    ".tmux" = {
      source = builtins.fetchGit {
        url = "git@github.com:gpakosz/.tmux.git";
        # owner = ".tmux";
        # repo = "gpakosz";
        rev = "129d6e7ff3ae6add17f88d6737810bbdaa3a25cf";
        # sha256 = "1r65pp1gpyrjnkvv820rik34fn8247kpdi828bn35yrnw4dhi32f";
        # leaveDotGit = true;
      };
    };
    ".tmux.conf".source = ~/.tmux/.tmux.conf;
    ".tmux.conf.local".source = ~/dotfiles/.tmux.conf.local;
    # ".config/.tmux.conf.local".source = ~/dotfiles/.tmux.conf.local;
    ".config/toxiproxy.json".source = ~/dotfiles/toxiproxy.json;
    "Projects/AdQuick/.tmuxinator.yml".source = ~/dotfiles/.tmuxinator.adquick.yml;
    # "Projects/AdQuick/adquick/lefthook.yml".source = ~/dotfiles/lefthook/lefthook.yml;
    "Projects/AdQuick/adquick/lefthook-local.yml".source = ~/dotfiles/lefthook/lefthook-local.yml;
    "Projects/AdQuick/adquick/.aider.conf.yml".source = ~/dotfiles/aider/.aider.conf.yml;
    ".config/tmuxinator/emamux.yml".source = ~/dotfiles/.tmuxinator.emamux.yml;
    ".newsboat/config".source = ~/dotfiles/newsboat/config;
    ".bin/eless".source = ~/.eless/eless;

    ".rbenv" = {
      # source = pkgs.fetchFromGitHub {
        # owner = "rbenv";
        # repo = "rbenv";
        # rev = "v1.3.2";
        # sha256 = "0zqd3dprfpxv2d44rk4zvq8s3fsmx4v1xwgrmf7j1dpc0phakd9y";
        # leaveDotGit = true;
      # };
      source = builtins.fetchGit {
        url = "git@github.com:rbenv/rbenv.git";
        rev = "10e96bfc473c7459a447fbbda12164745a72fd37";
      };
      recursive = true;
    };

    ".rbenv/plugins/ruby-build" = {
      source = builtins.fetchGit {
        url = "git@github.com:rbenv/ruby-build.git";
        rev = "cb9c1decb3b7c3c0fcd8a4368bb6a492e631b570";
        # sha256 = "0zqd3dprfpxv2d44rk4zvq8s3fsmx4v1xwgrmf7j1dpc0phakd9y";
        # leaveDotGit = true;
      };
      # source = pkgs.fetchFromGitHub {
      #   owner = "rbenv";
      #   repo = "ruby-build";
      #   rev = "20250130";
      #   sha256 = "0zqd3dprfpxv2d44rk4zvq8s3fsmx4v1xwgrmf7j1dpc0phakd9y";
      #   leaveDotGit = true;
      # };
      recursive = true;
    };

    ".eless" = {
      source = builtins.fetchGit {
        url = "git@github.com:kaushalmodi/eless.git";
        rev = "ee570e8987a34323cb229aa1b8b60b030590c7cf";
      };
      recursive = true;
    };

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
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "Morantron/tmux-fingers"; } # Simple plugin installation
        { name = "tmux-plugins/tmux-logging"; } # Simple plugin installation
        { name = "robhurring/tmux-spotify"; } # Simple plugin installation
        { name = "schasse/tmux-jump"; } # Simple plugin installation
        { name = "dracula/tmux"; } # Simple plugin installation
        # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
 programs.atuin = {
    enable = true;
    enableZshIntegration = true;
 };

  programs.direnv = {
      enable = true;
      # enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
  };

  # programs.bash.enable = true; # see note on other shells below
}
