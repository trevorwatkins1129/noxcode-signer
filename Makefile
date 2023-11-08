# Makefile for building and packaging an iOS app

# Define your variables
appName = YourAppName
identifier = YourBundleIdentifier

.PHONY: all clean

all: build

build:
	xcodebuild -project $(appName).xcodeproj \
		-scheme $(appName) \
		-sdk iphoneos \
		archive -archivePath ./archive \
		CODE_SIGNING_REQUIRED=NO \
		AD_HOC_CODE_SIGNING_ALLOWED=YES \
		CODE_SIGNING_ALLOWED=NO \
		DEVELOPMENT_TEAM=XYZ0123456 \
		ORG_IDENTIFIER=com.$(identifier) \
		DWARF_DSYM_FOLDER_PATH="."

	mkdir -p Payload
	mkdir -p Payload/$(appName).app
	cp -R archive.xcarchive/Products/Applications/$(appName).app/ Payload/$(appName).app/
	zip -r $(appName).ipa Payload

fake-sign:
	./fakesign.sh $(appName).ipa

clean:
	rm -rf archive Payload $(appName).ipa

