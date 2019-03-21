PHONY :=
PROJECT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Include stonehenge ENV variables
include .env

# Include stonehenge makefile
include $(PROJECT_DIR)/make/stonehenge.mk

.PHONY: $(PHONY)
