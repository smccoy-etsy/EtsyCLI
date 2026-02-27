#exit script immediately if any command returns a non-zero exit code (indicating an error)
set -o errexit

#Kill xcode
kill $(ps aux | grep 'Applications/Xcode.app/Contents/MacOS/Xcode' | grep -v 'grep' | awk '{print $2}')

#Delete derived data
cd $HOME/Library/Developer/Xcode/DerivedData
rm -rf *

#Re-launch Xcode
open -a Xcode