{ config, pkgs, lib, ... }:

{
  home.username = "maxi";
  home.homeDirectory = "/home/maxi";

  home.stateVersion = "26.05";

  home.file = {
    ".p10k.zsh".source = ./programs/zsh/p10k.zsh;
    ".clang-format".source = ./programs/clang/clang-format;
    ".clangd".source = ./programs/clang/clangd;
    ".vim".source = ./programs/vim/.vim;
    ".local/bin/tmux-sessionizer" = {
      source = ./programs/tmux/tmux-sessionizer;
      executable = true;
    };
  };

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Personal/my-notes";
  };

  home.packages = with pkgs; [
    gcc

    cmake
    ninja
    ccache
    pkg-config

    gdb

    python3

    neovim

    lua-language-server
    stylua

    clang-tools

    cmake-lint
    cmake-format

    ruff
    shfmt

    typos-lsp

    tree-sitter
    lazygit
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Aditya Raj";
      user.email = "adityaraj6508@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "ls --color";
      ac = "activate";
      dac = "deactivate";
      td = "tmux_default";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkBefore ''
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      '')

      (lib.mkOrder 1000 ''
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Keybindings
      bindkey -e
      bindkey '^p' up-line-or-search
      bindkey '^n' down-line-or-search

      # History
      HISTSIZE=5000
      HISTFILE=~/.zsh_history
      SAVEHIST=$HISTSIZE
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no

      # fzf-tab previews
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      # Automatically attach to tmux outside SSH
      tmux_default() {
        if command -v tmux &>/dev/null; then
          if [[ -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
            tmux new-session -A -s start -c ~
          fi
        fi
      }

      # Find a directory by walking up the current directory tree
      search_directory() {
        local target_directory="$1"
        local current_directory="$(pwd)"

        while [[ "$current_directory" != "/" ]]; do
          if [[ -d "$current_directory/$target_directory" ]]; then
            echo "$current_directory/$target_directory"
            return 0
          fi
          current_directory="$(dirname "$current_directory")"
        done

        echo "Directory '$target_directory' not found." >&2
        return 1
      }

      # Activate the nearest venv
      activate() {
        local directoryName
        directoryName="$(search_directory venv)" || return 1

        if [[ ! -f "$directoryName/bin/activate" ]]; then
          echo "Activate script not found in '$directoryName'."
          return 1
        fi

        source "$directoryName/bin/activate"
      }

      # Load Powerlevel10k user configuration
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      tmux_default
      '')
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
  
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.catppuccin;

        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_text "#W"
          set -g @catppuccin_window_current_text "#W"
        '';
      }

      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
  
    extraConfig = ''
      # Reload configuration
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
  
      # Terminal and Nerd Font support
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ',*:Tc:fonts=NerdFonts'
  
      # Status bar
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-interval 5
      set -g status-position top
  
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"
  
      # Mouse and copy mode
      set -g mouse on
      setw -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
  
      # Window and pane numbering
      set -g base-index 1
      set -g pane-base-index 1
      set-option -g renumber-windows on
  
      # Pane navigation
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
  
      # Sessionizer
      bind-key -r s run-shell "tmux neww ~/.local/bin/tmux-sessionizer s"
      bind-key -r f run-shell "tmux neww ~/.local/bin/tmux-sessionizer d"
  
      # Custom splits
      unbind %
      unbind '"'
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
  
      # New windows inherit the current directory
      bind c new-window -c "#{pane_current_path}"
    '';
  };

  programs.vim = {
    enable = true;

    extraConfig = ''
      " Terminal support
      set termguicolors
      let g:tokyonight_style = 'night'
      let g:tokyonight_enable_italic = 1
      colorscheme tokyonight

      " Cursor shape
      let &t_SI = "\e[5 q"
      let &t_EI = "\e[1 q"

      " Leaders
      let mapleader = "\<Space>"
      let maplocalleader = "\<Space>"

      " General settings
      set mouse=a
      set smartindent
      set expandtab
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4

      set number
      set relativenumber
      set ruler
      set wrap
      set scrolloff=8

      set path+=**
      set wildmenu
      set clipboard=unnamedplus

      syntax on
      set foldmethod=syntax
      set foldlevel=3

      set showmatch
      set incsearch

      " Cursor line
      set cursorline
      au WinEnter,FocusGained * set cursorline
      au WinLeave,FocusLost * set nocursorline

      " Visual mode
      vnoremap <C-j> :m '>+1<CR>gv=gv
      vnoremap <C-k> :m '<-2<CR>gv=gv
      vnoremap ; :

      " Normal mode
      nnoremap ; :
      nnoremap j gj
      nnoremap k gk
      nnoremap <C-s> <CMD>w<CR>
      nnoremap <C-q> <CMD>qa<CR>
      nnoremap <C-j> <CMD>m+1<CR>==
      nnoremap <C-k> <CMD>m-2<CR>==
      nnoremap <C-d> <C-d>zz
      nnoremap <C-u> <C-u>zz

      " Insert mode
      inoremap <C-s> <ESC><CMD>w<CR>
      inoremap <C-j> <CMD>m+1<CR><C-o>==
      inoremap <C-k> <CMD>m-2<CR><C-o>==
    '';
  };
}
