# disable greeting
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

# !$
function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end


#util aliases
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias upd='sudo reflector --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syu && fish_update_completions && sudo updatedb'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB (expac must be installed)
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages

alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist" 
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist" 
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist" 
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist" 

alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

#aliases
# alias clear='/usr/bin/clear && colorscript -r'
alias clear='/usr/bin/clear && bullshit | awk \'{print $1}\' | figlet -t | lolcat -S 12 -p 10.0'
alias mkdirc='mkdir $argv && cd '
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias prime='DRI_PRIME=1'
alias primerun='DRI_PRIME=1 mangohud gamemoderun proton'
alias upload='curl -F "file=@$argv" http://0x0.st; echo '
alias share='curl -F "file=@$argv" -Fexpires=24 http://0x0.st; echo '
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
alias lvide='NEOVIDE_MULTIGRID=1 NEOVIDE_VSYNC=1 neovide-lunarvim'
alias json='prettier --parser json'
alias pixel='QT_QPA_PLATFORM=xcb emulator -avd Pixel8'

# Lines of Code
function loc
    if test (count $argv) -eq 0
        echo "Usage: loc <extension>"
        return 1
    end
    find . -name "*.$argv[1]" -print0 | xargs -0 wc -l
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    clear
end

starship init fish | source

zoxide init fish | source

export EDITOR='nvim'
export VISUAL='nvim'

thefuck --alias | source
