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
PS1='\[\e]0;\u@\h: \w\a\]\[\033[32m\]\u@\h \[\033[33;1m\]\w\[\033[36m\]$(parse_git_info)\[\033[00m\] \$ '

# pacman
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias paki='paru -S'

# video wallpaper commands
alias video='bash /home/faiyaz/.config/mpvpaper/autovideo.s > /dev/null 2>&1 &'
alias novideo='bash /home/faiyaz/.config/mpvpaper/forcekill.sh'
alias unlock='pkill -f bakalock.sh && pkill -f mpvpaper'
alias wallpaper='swww img "/home/faiyaz/Desktop/wallpapers/RDT_20220205_2330068786074992053066103.jpg"'
alias download='cd ~/Desktop/videowallpaper && bash /home/faiyaz/.config/mpvpaper/download.sh'

# git access token
alias gitaccess='cat /home/faiyaz/GitAccessToken'

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

alias drive='sudo mount /dev/sdc1 /pendrive'

# firewall-cmd commands
alias panic='sudo firewall-cmd --panic-on'
alias calm='sudo firewall-cmd --panic-off'
alias arepanic='sudo firewall-cmd --query-panic'

export TESSDATA_PREFIX=/usr/share/tessdata/
