OS_RELEASE_FILE_EXISTS := $(shell test -f /etc/os-release && echo yes || echo no)
UNAME := $(shell uname | tr A-Z a-z)

# Detect OS and related information
ifeq ($(UNAME),darwin)
	OS_VERSION := $(shell sw_vers -productVersion)
ifeq ($(OS_VERSION),10.15)
	OS := macOS Catalina
else ifeq ($(OS_VERSION),10.14)
	OS := macOS Mojave
else ifeq ($(OS_VERSION),10.13)
	OS := macOS High Sierra
endif
	OS_ID := macos
	OS_ID_LIKE := $(UNAME)
else ifeq ($(OS_RELEASE_FILE_EXISTS),yes)
	# Ubuntu 18.04.3 LTS (Bionic Beaver) / Manjaro Linux
	OS := $(shell . /etc/os-release && echo "$${PRETTY_NAME}")
	# ubuntu / manjaro
	OS_ID := $(shell . /etc/os-release && echo "$${ID}")
	# debian / arch
	OS_ID_LIKE := $(shell . /etc/os-release && echo "$${ID_LIKE}")
	# e.g. Ubuntu can give: 18.04
	OS_VERSION := $(shell . /etc/os-release && echo "$${VERSION_ID}")
else
	OS := $(UNAME)
	OS_ID := UNKNOWN
	OS_ID_LIKE := UNKNOWN
	OS_VERSION := UNKNOWN
endif

ifeq ($(OS_ID_LIKE),darwin)
	BREW_BIN := $(shell which brew || echo no)
endif
