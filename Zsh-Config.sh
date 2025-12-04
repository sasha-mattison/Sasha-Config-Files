# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
#source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

rld() {
    clear
    source ~/.zshrc
}

ff() {
    fastfetch
}

mkd() {
    if [ -z "$1" ]; then
        echo "Usage: mkd <directory-name>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

updt() {    
    sudo pacman -Syu
    clr
}

clr() {
    clear
    fastfetch
}

reload() {
    clear
    source ~/.zshrc
    ff
    updt
}

foreverfetch() {
    while true; do
    clear
    fastfetch
    sleep 1
done
}

gitpk() {
    cd ~
    cd Documents
    cd GitHub
}

_pm_do() {
    local action="$1"
    shift

    case "$action" in
        install)
            sudo pacman -S "$@"
            ;;
        remove)
            sudo pacman -R "$@"
            ;;
        search)
            pacman -Ss "$@"
            ;;
        info)
            pacman -Qi "$@"
            ;;
        *)
            echo -e "${RED}Unknown pm action: $action${RESET}"
            return 1
            ;;
    esac
}

add() {
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}Usage: add <pkg1> [pkg2...]${RESET}"
        return 1
    fi
    if _pm_do install "$@"; then
        echo -e "${GREEN}✔ Successfully installed: $@${RESET}"
    else
        echo -e "${RED}✘ Failed to install: $@${RESET}"
    fi
}

install() { add "$@"; }

remove() {
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}Usage: remove <pkg1> [pkg2...]${RESET}"
        return 1
    fi
    if _pm_do remove "$@"; then
        echo -e "${GREEN}✔ Successfully removed: $@${RESET}"
    else
        echo -e "${RED}✘ Failed to remove: $@${RESET}"
    fi
}

rm() { remove "$@"; }

search() {
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}Usage: search <term>${RESET}"
        return 1
    fi
    _pm_do search "$@"
}

find() { search "$@"; }

info() {
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}Usage: info <pkg>${RESET}"
        return 1
    fi
    _pm_do info "$@"
}

help() { info "$@"; }


ff
eval "$(starship init zsh)"