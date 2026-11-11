include .env
export

WOW_ADDON_PATH := "$(WOW_PATH)/Interface/AddOns/FamilyNames"

.PHONY: load

load:
	mkdir -p $(WOW_ADDON_PATH)
	cp *.toc *.lua $(WOW_ADDON_PATH)/
