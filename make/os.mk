OS_RELEASE_FILE := /etc/os-release
OS_RELEASE_FILE_EXISTS := $(shell test -f $(OS_RELEASE_FILE) && echo yes || echo no)
UNAME := $(shell uname | tr A-Z a-z)

# Detect OS and related information

#
# macOS
#
ifeq ($(UNAME),darwin)
	OS_ID := macos
	OS_VERSION := $(shell sw_vers -productVersion)
ifeq ($(OS_VERSION),10.15)
	OS := macOS Catalina
else ifeq ($(OS_VERSION),10.14)
	OS := macOS Mojave
else ifeq ($(OS_VERSION),10.13)
	OS := macOS High Sierra
else
	OS := macOS $(OS_VERSION)
	OS_ID := UNKNOWN
endif
	OS_ID_LIKE := $(UNAME)
#
# Linux distros with /etc/os-release file
#
else ifeq ($(OS_RELEASE_FILE_EXISTS),yes)
	# Ubuntu 18.04.3 LTS (Bionic Beaver) / Manjaro Linux / Arch Linux
	OS := $(shell . $(OS_RELEASE_FILE) && echo "$${PRETTY_NAME}")
	# ubuntu / arch / manjaro
	OS_ID := $(shell . $(OS_RELEASE_FILE) && echo "$${ID}")
	# debian / arch
	OS_ID_LIKE := $(shell . $(OS_RELEASE_FILE) && echo "$${ID_LIKE}")
ifeq ($(OS_ID),arch)
	OS_ID_LIKE := arch
endif
	# e.g. Ubuntu can give: 18.04
	OS_VERSION := $(shell . $(OS_RELEASE_FILE) && echo "$${VERSION_ID}")
#
# Others
#
else
	OS := $(UNAME)
	OS_ID := UNKNOWN
	OS_ID_LIKE := UNKNOWN
	OS_VERSION := UNKNOWN
endif

#
# Not supported!
#
ifeq ($(OS_ID),UNKNOWN)
$(error OS $(OS) not supported)
endif

#
# macOS additions
#
ifeq ($(OS_ID_LIKE),darwin)
	BREW_BIN := $(shell which brew || echo no)
endif
