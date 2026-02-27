#cd to the directory this file is in
DIRECTORY=$(dirname "$0")
cd "$DIRECTORY"

sudo cp $(ls | grep -v README | grep -v install) /usr/local/bin/
