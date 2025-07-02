{  config, pkgs,self, ... }:

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
  home.homeDirectory = "/home/omp";
  home.stateVersion = "24.05";

  # Packages
  home.packages = with pkgs; [
    hello
    cowsay
    gnused
    jqp
    ncdu
    htop
    btop
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
    # bieye
    cmatrix
    eza
    luajitPackages.luarocks
    luajitPackages.penlight
    luajitPackages.luafilesystem
    gccgo14
    ripgrep
    tree
    stow
    mongodb-compass
    # For Chrome, you might need:
    google-chrome 
    vscode
    docker_27
    docker-compose
    ollama
    fd
    # picom
    # wezterm
    nerd-fonts.jetbrains-mono
    git-credential-manager
    lazydocker
    dnsutils
    # DNS and networking tools
    curl
    # code-cursor
  ];

  # Use `builtins.toPath` to convert the home directory path correctly
  home.file.".p10k.zsh".source = "${self.source.p10k}";
  home.file.".config/wezterm/wezterm.lua".source = ./wezterm/.config/wezterm/wezterm.lua;
  home.file.".luarocks/config.lua".text = ''
    rocks_trees = {
      { name = "user", root = "${config.home.homeDirectory}/.luarocks" }
    }
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
    LANG = "en_IN.UTF-8";
    LC_ALL = "en_IN.UTF-8";
    ZSH = "$HOME/.oh-my-zsh";
    LUA_PATH = "${config.home.homeDirectory}/.luarocks/share/lua/5.1/?.lua;;";
    LUA_CPATH = "${config.home.homeDirectory}/.luarocks/lib/lua/5.1/?.so;;";
    FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'";

  };

  # neovim config
  programs.neovim = {
    enable = true;
    viAlias = true; # optional, if you want to use `vi` as a symlink to nvim
  };
  # Use home.file to symlink each Neovim configuration file or folder
  home.file.".config/nvim/init.lua".source = ./nvim/.config/nvim/init.lua;
  home.file.".config/nvim/lazy-lock.json".source = ./nvim/.config/nvim/lazy-lock.json;
  home.file.".config/nvim/LICENSE".source = ./nvim/.config/nvim/LICENSE;
  home.file.".config/nvim/README.md".source = ./nvim/.config/nvim/README.md;
  home.file.".config/nvim/lua".source = ./nvim/.config/nvim/lua;
  home.file.".tmux.conf".source = ./tmux/.tmux.conf;

  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "manager-core";
      credential.credentialStore = "cache";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "nix flake update";
      cd = "z";
    };

    # Use initExtra to define configurations after Oh My Zsh is loaded
    initExtra = ''
      export LC_ALL=en_US.UTF-8
      export DISPLAY=:0
      # Disable compfix check for completions
      export ZSH_DISABLE_COMPFIX=true
      export ZSH="$HOME/.oh-my-zsh"
      
      export GIT_ASKPASS=true
      git config --global --replace-all credential.helper manager-core
      git-credential-manager configure

      
      ZSH_THEME="powerlevel10k/powerlevel10k"
      plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)

      # Check for fzf config
      if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
      else
        echo "[initExtra] ~/.fzf.zsh not found, skipping fzf initialization"
      fi

      # Source Powerlevel10k config if present
      if [ -f ~/.p10k.zsh ]; then
        source ~/.p10k.zsh
      else
        echo "[initExtra] ~/.p10k.zsh not found, skipping P10k config"
      fi

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

      # FZF configurations
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
      if command -v fd >/dev/null; then
        export FZF_CTRL_T_COMMAND='fd --type f'
        export FZF_ALT_C_COMMAND='fd --type d'
      else
        echo "[initExtra] 'fd' not found; fzf file/dir commands not set."
      fi
      export FZF_CTRL_R_OPTS='--sort --height 40% --layout=reverse --border'

      if command -v fzf >/dev/null; then
        bindkey '^R' fzf-history-widget
        bindkey '^T' fzf-file-widget
        bindkey '^C' fzf-cd-widget
      else
        echo "[initExtra] 'fzf' not found; no keybindings for fzf widgets."
      fi

      # Initialize zoxide if available
      if command -v zoxide >/dev/null; then
        eval "$(zoxide init zsh)"
      else
        echo "[initExtra] 'zoxide' not found, skipping."
      fi

      # zsh-autocomplete plugin
      if [ -f ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
        source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      else
        echo "[initExtra] zsh-autocomplete plugin not found."
      fi

      # Source Oh My Zsh
      if [ -f $ZSH/oh-my-zsh.sh ]; then
        source $ZSH/oh-my-zsh.sh
      else
        echo "[initExtra] Oh My Zsh not found at $ZSH/oh-my-zsh.sh."
      fi

      # Unalias ls if already set
      unalias ls 2>/dev/null

      # Define custom ls alias if eza is available
      if command -v eza >/dev/null; then
        alias ls='eza --long --group-directories-first --header --icons --color=always'
      else
        echo "[initExtra] 'eza' not found, using default ls."
      fi

      # If luarocks is available, set up its path
      if command -v luarocks >/dev/null; then
        eval $(luarocks path --bin)
      else
        echo "[initExtra] 'luarocks' not found, skipping Lua path setup."
      fi

      # Restart picom with a specified backend if available
      if command -v picom >/dev/null; then
        if command -v pkill >/dev/null; then
          pkill picom
        else
          echo "[initExtra] 'pkill' not found; cannot kill previous picom instance."
        fi
        
        # Try starting picom with glx backend
        if picom -b --backend glx; then
          echo "[initExtra] picom started with glx backend."
        else
          echo "[initExtra] Failed to start picom with glx, trying xrender..."
          if picom -b --backend xrender; then
            echo "[initExtra] picom started with xrender backend."
          else
            echo "[initExtra] Failed to start picom with any known backend."
          fi
        fi
      else
        echo "[initExtra] 'picom' not found, skipping compositor restart."
      fi

      
    '';

  };
  programs.home-manager.enable = true;

  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.ripgrep.enable = true;
}
