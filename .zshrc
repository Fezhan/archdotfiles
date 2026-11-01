# ==============================
# ZSH CORE SETTINGS
# ==============================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fast-syntax-highlighting )

export ZSH_CUSTOM="$ZSH/plugins"

source $ZSH/oh-my-zsh.sh


# History
HISTFILE=~/.zshhistfile
HISTSIZE=1000
SAVEHIST=1000

setopt hist_ignore_all_dups
setopt share_history

bindkey -e

# ==============================
# COMPLETION
# ==============================

zstyle :compinstall filename '/home/handesh/.zshrc'

autoload -Uz compinit
compinit

# ==============================
# USEFUL ZSH OPTIONS
# ==============================

setopt autocd
setopt correct

# ==============================
# COLORS
# ==============================

autoload -Uz colors vcs_info
colors
setopt PROMPT_SUBST

# ==============================
# GIT PROMPT (Native Zsh)
# ==============================

precmd() {
  vcs_info
  if [[ -n ${vcs_info_msg_0_} ]]; then
    local repo_name
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    # Strip existing parentheses, format cleanly as (repo-branch)
    vcs_info_msg_0_=" (${repo_name}-${vcs_info_msg_0_//[()]/})"
  fi
}
# Removed the parentheses from the format string here so they don't double up
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:*' enable git

PROMPT='%{$fg[green]%}%n@%m %{$fg[yellow]%}%~%{$fg_bold[cyan]%}${vcs_info_msg_0_}%{$reset_color%} '
# ==============================
# ALIASES
# ==============================

alias ls='exa -al'
alias la='exa -a'
alias lt='exa -T'

alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias powershell='pwsh'

# pacman
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias paki='paru -S'

# WLAN
alias wlan0on='sudo ip link set wlan0 up'
alias wlan0off='sudo ip link set wlan0 down'

# video wallpaper
alias video='bash ~/.config/mpvpaper/autovideo.sh > /dev/null 2>&1 &'
alias novideo='bash ~/.config/mpvpaper/forcekill.sh'
alias unlock='pkill -f bakalock.sh && pkill -f mpvpaper'
alias wallpaper='swww img "$HOME/Desktop/wallpapers/wp7997723-colossal-titan-wallpapers.jpg"'
alias superdownloader='$HOME/.config/scripts/superdownloader.sh'

alias gitaccess='cat ~/GitAccessToken'
alias HyprlandConf='vim ~/.config/hypr/hyprland.conf'

alias biggus='echo -e "\nDickus!\n" && sudo'

alias raspi='ssh levihackermann@192.168.1.112'
alias gaming='ssh levihackermann@gaming'
alias imager='sudo -E rpi-imager'

alias public='echo -e "\033[0;31m$(curl -s ipv4.icanhazip.com)\033[0m"'
alias private='ip a show wlp4s0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"'

alias drive='sudo mount /dev/sdb1 /media'
alias removesymlink='find . -type l -delete'

alias jelly='sudo systemctl start jellyfin'
alias serve='systemctl start jellyfin'
alias die='systemctl stop jellyfin'

alias panic='sudo firewall-cmd --panic-on'
alias calm='sudo firewall-cmd --panic-off'
alias arepanic='sudo firewall-cmd --query-panic'

alias multivol='$HOME/.config/scripts/sinks.sh'

alias bright='brightnessctl set 100%'
alias dark='brightnessctl set 0%'

alias fixvideo='
systemctl --user restart pipewire
systemctl --user restart pipewire-pulse
systemctl --user restart wireplumber
'

alias userd='systemctl --user'

rootme() {
    sudo chown root:root "$1"
    sudo chmod 644 "$1"
    echo "Ownership and permissions updated for $1"
}

autoload -U compinit
compinit

bindkey -e
bindkey "${terminfo[kdch1]}" delete-char



# ==============================
# FUNCTIONS
# ==============================

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ==============================
# ENVIRONMENT VARIABLES
# ==============================

export TESSDATA_PREFIX=/usr/share/tessdata/
export XCURSOR_THEME=BreezeX-Dark
export XCURSOR_SIZE=24
export PATH="$PATH:/home/handesh/.local/bin"
export HYPRSHOT_DIR=~/Desktop/Screenshots

export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export GDK_BACKEND=wayland,x11
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export EDITOR=vim
export MANPAGER="less -R"
export PAGER="less"

