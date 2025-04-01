#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

# Function to parse git branch and repository name
parse_git_info() {
    local branch
    branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [ -n "$branch" ]; then
        local repo_name
        repo_name=$(basename "$(git rev-parse --show-toplevel)")
        echo " ($repo_name-$branch)"
    fi
}

# Customized PS1 with Git branch and repository name display
PS1='\[\e]0;\u@\h: \w\a\]\[\033[32m\]\u@\h \[\033[33;1m\]\w\[\033[36m\]$(parse_git_info)\[\033[00m\] '

# pacman
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias paki='paru -S'

# video wallpaper commands
alias video='bash ~/.config/mpvpaper/autovideo.sh > /dev/null 2>&1 &'
alias novideo='bash ~/.config/mpvpaper/forcekill.sh'
alias unlock='pkill -f bakalock.sh && pkill -f mpvpaper'
alias wallpaper='swww img "~/Desktop/wallpapers/wp7997723-colossal-titan-wallpapers.jpg"'
alias download='cd ~/Desktop/videowallpaper && bash ~/.config/mpvpaper/download.sh'

# git access token
alias gitaccess='cat ~/GitAccessToken'

# mullvad account
alias vpn='echo "7538929427288099"'

# sudo config
alias biggus='echo -e "\nDickus!\n" && sudo'

# ls configs
alias ls='exa -al'
alias la='exa -a'
alias lt='exa -T'

# SSH configs

alias shmaster='ssh levihackermann@192.168.1.112'
alias shslave='ssh levihackermann@192.168.1.251'

# RPI Imager

alias imager='sudo -E rpi-imager'

# IP

alias public='echo -e "\033[0;31m$(curl -s ipv4.icanhazip.com)\033[0m"'
alias private='ip a show wlo1 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"'


# Mount Drive

alias drive='sudo mount /dev/sdb1 /media'

# symbolic link remover
alias removesymlink='find . -type l -delete'


# Start Jellyfin

alias jelly='sudo systemctl start jellyfin'

# If videos aren't playing in MPVPlayer or jellyfin, run this link

alias fixvideo='systemctl --user restart pipewire
systemctl --user restart pipewire-pulse
'

# firewall-cmd commands
alias panic='sudo firewall-cmd --panic-on'
alias calm='sudo firewall-cmd --panic-off'
alias arepanic='sudo firewall-cmd --query-panic'


# Easy add combined audio profile
alias multivol='~/scripts/./sinks.sh'

# Start the jellyfin server
alias serve='systemctl start jellyfin'
alias die='systemctl stop jellyfin'

# Brightness
alias bright='brightnessctl set 100%'
alias dark='brightnessctl set 0%'

export TESSDATA_PREFIX=/usr/share/tessdata/

# ~/.profile or ~/.bashrc
export XCURSOR_THEME=BreezeX-Dark
export XCURSOR_SIZE=24


# Created by `pipx` on 2024-12-15 23:38:28
export PATH="$PATH:/home/handesh/.local/bin"


# Hyprshot save location
export HYPRSHOT_DIR=~/Desktop/Screenshots
