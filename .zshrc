export ZSH="$HOME/.oh-my-zsh"

# Path
# Ensure the 'path' array is unique for deduplication
typeset -U path

# Custom paths
path=(
  /home/daveydark/.config/composer/vendor/bin
  /usr/bin/flutter/bin
  /home/daveydark/Android/Sdk/platform-tools
  /home/daveydark/Android/Sdk/emulator
  /home/daveydark/.cargo/bin
  /home/daveydark/.local/bin
  /home/daveydark/.config/hypr/scripts
  $path
)

# Explicitly export PATH
export PATH

# Env vars
ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"

# Style changes
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':completion:*' menu no # Don't show completiton menu (to allow fzf-tab)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'


# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zoxide starship copybuffer copypath copyfile dirhistory fzf web-search fzf-tab jsontools colorize sudo)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

## User Configuration
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# History search config
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt appendhistory
unsetopt sharehistory
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Configure backspace to delete a single character (default behavior)
bindkey '^?' backward-delete-char

# Configure Ctrl + Backspace to delete a word
bindkey '^H' backward-kill-word
## Functions
# backup function
backup() {
    local filename="$1"
    cp "$filename" "${filename}.bak"
}

# Lines of Code (loc) function
loc() {
    if (( $# == 0 )); then
        echo "Usage: loc <extension>"
        return 1
    fi
    find . -name "*.$1" -print0 | xargs -0 wc -l
}

function whereis-command() {
    emulate -L zsh
    setopt extendedglob

    local cmd=${BUFFER%% *}
    [[ -z $cmd ]] && return 0

    local message=""

    if alias $cmd >/dev/null 2>&1; then
        message="alias: $(alias $cmd)"
    elif whence -w $cmd | grep -q 'function'; then
        message="function: $(whence -f $cmd | head -n 1)"
    elif whence -w $cmd | grep -q 'builtin'; then
        message="$cmd is a shell builtin"
    elif local path=$(command -v $cmd); then
        message="binary: $path"
    else
        message="$cmd: not found"
    fi

    # Show in ZLE's message area (non-blocking)
    zle -M "$message"
}

zle -N whereis-command
bindkey '^[w' whereis-command

## Aliases
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias upd='sudo reflector --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syu && sudo updatedb'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# aliases
alias ls='eza -al --color=always --group-directories-first --icons=always'
alias la='eza -a --color=always --group-directories-first --icons=always'
alias ll='eza -l --color=always --group-directories-first --icons=always'
alias lt='eza -aT --color=always --group-directories-first --icons=always'
alias prime='DRI_PRIME=1'
alias primerun='DRI_PRIME=1 mangohud gamemoderun proton'
alias upload='curl -F "file=@$argv[1]" http://0x0.st; echo ' # Zsh's $argv becomes "$1"
alias share='curl -F "file=@$argv[1]" -Fexpires=24 http://0x0.st; echo ' # Zsh's $argv becomes "$1"
alias prun='STEAM_COMPAT_CLIENT_INSTALL_PATH=~/.local/share/Steam/ STEAM_COMPAT_DATA_PATH=~/.local/share/Steam/steamapps/compatdata/common/ ~/.local/share/Steam/steamapps/common/Proton\ 8.0/proton run'
alias swaylock='swaylock \
    --screenshots \
    --clock \
    --indicator \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --effect-blur 7x5 \
    --effect-vignette 0.5:0.5 \
    --ring-color bb00cc \
    --key-hl-color 880033 \
    --line-color 00000000 \
    --inside-color 00000088 \
    --separator-color 00000000 \
    --grace 2 \
    --fade-in 0.2'
alias pixel='QT_QPA_PLATFORM=xcb emulator -avd Pixel8'
