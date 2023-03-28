
CONFIG_PATH:=$(HOME)/.config/nvim

all:
	@ls -al $(CONFIG_PATH)
	@if [ ! -d "$(CONFIG_PATH)" ]; then ln -s `pwd` ~/.config/nvim; fi
	@ls -al $(CONFIG_PATH)
