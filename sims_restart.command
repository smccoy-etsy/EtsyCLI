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

green "Shutting sims down"
xcrun simctl shutdown all
xcrun simctl --set testing shutdown all

green "Done!"