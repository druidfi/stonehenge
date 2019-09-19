.DEFAULT_GOAL := help
PHONY :=
PROJECT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SHELL := /bin/bash

# Include Stonehenge ENV variables
include .env

# Include Stonehenge makefiles
include $(PROJECT_DIR)/make/*.mk

.PHONY: $(PHONY)
