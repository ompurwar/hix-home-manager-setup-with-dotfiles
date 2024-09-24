{ config, pkgs, ... }:

let
  bieye = pkgs.stdenv.mkDerivation rec {
    pname = "bieye";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "ismet55555";
      repo = "bieye";
      rev = "main";
      sha256 = "sha256-dbNSz95oTaPWsvqrNdgUp0ONAt29ZuezgWYVjzGbCHY=";
    };

    buildInputs = [ pkgs.rustc pkgs.cargo ];

    buildPhase = ''
      echo "Building Bieye with Cargo"
      export CARGO_HOME=$TMPDIR/cargo
      mkdir -p $CARGO_HOME
      cargo build --release
    '';

    installPhase = ''
      echo "Installing Bieye"
      mkdir -p $out/bin
      cp target/release/bieye $out/bin/
    '';

    meta = with pkgs.lib; {
      description = "Terminal binary viewer for Unix systems";
      homepage = "https://github.com/ismet55555/bieye";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

in
{
  home.username = "omp";

  # Correctly set the home directory to a valid path
  home.homeDirectory = pkgs.lib.mkForce ("/home/omp");

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    hello
    cowsay
    gnused
    jqp
    ncdu
    htop
    lazygit
    man-db
    atuin
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    fasd
    autojump
    zoxide
    fzf
    zsh-powerlevel10k
    bat
    tmux
    bieye
  ];

  home.file.".zshrc".text = ''
    export ZSH="$HOME/.oh-my-zsh"

    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)

    autoload -Uz compinit
    compinit

    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_COMMAND='fd --type f'
    export FZF_ALT_C_COMMAND='fd --type d'
    export FZF_CTRL_R_OPTS='--sort --height 40% --layout=reverse --border'

    autoload -U bashcompinit
    bashcompinit

    bindkey '^R' fzf-history-widget
    bindkey '^T' fzf-file-widget
    bindkey '^C' fzf-cd-widget

    source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    source $ZSH/oh-my-zsh.sh
    eval "$(zoxide init zsh)"
  '';

  # Use `builtins.toPath` to convert the home directory path correctly
  home.file.".p10k.zsh".source = builtins.toPath "${config.home.homeDirectory}/.p10k.zsh";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
    LANG = "en_IN.UTF-8";
    LC_ALL = "en_IN.UTF-8";
    ZSH = "$HOME/.oh-my-zsh";
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.neovim.enable = true;
  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;

  programs.zsh.shellAliases = {
    "ls" = "exa --long --group-directories-first --header --icons";
    "update" = "nix flake update";
    "cd" = "z";
  };
}

