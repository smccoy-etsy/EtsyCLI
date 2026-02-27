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

green "Erasing sims"
xcrun simctl erase all
xcrun simctl --set testing erase all

green "Killing simulator app processes"
ps -efw | grep CoreSimulator | grep Users | grep \.app | grep -v grep | awk '{print $1}'


green "Killing simulator app processes' parent processes"
ps -efw | grep CoreSimulator | grep Users | grep \.app | grep -v grep | awk '{print $2}'

green "Done!"