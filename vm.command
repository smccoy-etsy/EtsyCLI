#!/bin/zsh

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

function yellow {
    color "$1" 3
}

function green {
    color "$1" 2
}

#Prompt to continue
function confirm {
    yellow "Press y to continue, any other key to exit"
    tput bel

    read -q "variable?"
    echo ""
    if [[ $variable != "y" && $variable != "Y" ]]
    then
        red "Exiting"
        say "Done"
        exit 0
    fi
    green "Continuing"
}

green "Checking gcloud status..."
ETSYWEBCTL_OUTPUT=$(etsywebctl vm list 2>&1)
if [[ "$ETSYWEBCTL_OUTPUT" == *"gcloud auth login"* ]]; then
    red "Re-authenticating with gcloud..."
    gcloud auth login --update-adc
else
    green "Logged in!"
fi


green "Gathering VM info..."
ETSYWEBCTL_OUTPUT=$(etsywebctl vm list | tail -1)
VM_NAME=$(echo "$ETSYWEBCTL_OUTPUT" | awk '{print $1}')
VM_URL=$(echo "$ETSYWEBCTL_OUTPUT" | awk '{print $2}')
green "Your VM is named $VM_NAME, and located at $VM_URL"

green "Connecting to VPN..."
osascript -e 'tell application "Viscosity" to connect "Etsy Prod VPN Okta"'
yellow "Confirm once connected to the VPN:"
confirm


green "Starting Virtual Machine..."
etsywebctl vm start $VM_NAME

if read -q "choice?Press Y/y to open Chrome to your VM page: "; then
    open -a "Google Chrome" "https://$VM_URL"
fi
echo ""

green "SSHing to VPN..."
green "If this hangs, check your VPN connection!"

ssh $VM_URL -t "cd development/Etsyweb/; bash --login"
