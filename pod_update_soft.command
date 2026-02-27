#!/bin/zsh

#exit script immediately if any command returns a non-zero exit code (indicating an error)
set -o errexit
trap "say 'Error installing pods!'" ERR

#Text coloring functions
function color {
    if tty -s
    then
        tput setaf $2
        echo "$1"
        tput sgr0
        return
    fi
    
    echo "$1"
}

function red {
    color "$1" 1
}

function green {
    color "$1" 2
}

green "Installing pods..."
arch -x86_64 pod install

say "Done installing pods"




