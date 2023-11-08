SHELL := /bin/bash
pull:
	$(info Pulling new commits…)
	git stash push || true
	git pull
	git stash pop || true
build:
	$(info Building xcodeproj...)
	@xcodebuild -project AltStore.xcodeproj \
				-scheme AltStore \
				-sdk iphoneos \
				archive -archivePath ./archive \
				CODE_SIGNING_REQUIRED=NO \
				AD_HOC_CODE_SIGNING_ALLOWED=YES \
				CODE_SIGNING_ALLOWED=NO \
				DEVELOPMENT_TEAM=XYZ0123456 \
				ORG_IDENTIFIER=com.SideStore \
				DWARF_DSYM_FOLDER_PATH="."
fakesign:
	$(info Injecting fakesign metadata...)
	./fakesign.sh ${appName}.ipa
ipa:
	$(info Packing IPA...)
	mkdir Payload
	mkdir Payload/${appName}.app
	cp -R archive.xcarchive/Products/Applications/SideStore.app/ Payload/SideStore.app/
	zip -r SideStore.ipa Payload
doall:
    $(info Pulling new commits…)
	git stash push || true
	git pull
	git stash pop || true
	$(info Building xcodeproj...)
    @xcodebuild -project ${appName}.xcodeproj \
				-scheme ${appName} \
				-sdk iphoneos \
				archive -archivePath ./archive \
				CODE_SIGNING_REQUIRED=NO \
				AD_HOC_CODE_SIGNING_ALLOWED=YES \
				CODE_SIGNING_ALLOWED=NO \
				DEVELOPMENT_TEAM=XYZ0123456 \
				ORG_IDENTIFIER=com.${identifier} \
				DWARF_DSYM_FOLDER_PATH="."
	$(info Packing IPA...)
    mkdir Payload
	mkdir Payload/${appName}.app
	cp -R archive.xcarchive/Products/Applications/${appName}.app/ Payload/${appName}.app/
	zip -r ${appName}.ipa Payload
	$(info Injecting fakesign metadata...)
    ./fakesign.sh ${appName}.ipa