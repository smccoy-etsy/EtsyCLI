cd /Users/smccoy/development/XCodeProjects/EtsyApp

tuist generate EtsyTests Collage --no-open

xcodebuild -workspace Etsy.xcworkspace -scheme Etsy -configuration Debug -derivedDataPath build/ -destination 'platform=iOS Simulator,id=5A4688EF-3337-40A3-83B4-CE79971EFB18' -enableCodeCoverage YES RUN_DOCUMENTATION_COMPILER='NO' build test