#!/bin/zsh

#Bail if any command fails
trap 'exit 1' ERR

# Validate args
if [ $# -eq 0 ]; then
    echo "Search for your app here: https://www.apple.com/us/search/"
    echo "get its ID number"
    echo "Then use download.command id_number_here"
    exit 1
fi

# Get json from the url and send it to jq
# jq to fetch the bundleId (-r is raw, to remove the quotes)
bundleId=$(curl --silent "https://itunes.apple.com/lookup?id=$1" | jq -r ".results .[0] | .bundleId")

#Check to see if ipatool is installed
if ! which ipatool > /dev/null 2>&1; then
	echo "ipatool not installed. Installing..."
	brew tap majd/repo
	brew install ipatool  
fi

# Make a new directory with a random in TMPDIR. This will be deleted automatically after 3 days of not being accessed.
cd $TMPDIR
dirName=$(openssl rand -base64 12 | tr -d '/+=_')
mkdir $dirName
cd $dirName

# Download the ipa
echo "Downloading app with Bundle ID: $bundleId. This may prompt for an AppleID's credentials/2FA code, or fail if downloading the app requires accepting Terms and Conditions..."

ipatool purchase -b "$bundleId"
ipatool download -b "$bundleId" --purchase


# Get the fileName
fileName=$(ls -t *.ipa | head -1)

# Unzip it
echo "Unzipping $fileName..."
unzip -qq $fileName

echo "Extracting CFBundleURLSchemes from Info.plist..."

# Find the Info.plist
plistPath=$(find . | grep app/Info.plist)

# Fetch the URLScheme
urlScheme=$(/usr/libexec/PlistBuddy -c "print :CFBundleURLTypes:0:CFBundleURLSchemes:0" $plistPath)
echo "URL Scheme: $urlScheme"
say "Done"