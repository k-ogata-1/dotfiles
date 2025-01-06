UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
	REBUILD := nix-darwin
	HOSTNAME := $(shell scutil --get ComputerName)
else ifeq ($(UNAME),Linux)
	REBUILD := nixos-rebuild
	HOSTNAME := $(shell hostname)
endif

.PHONY: switch
switch:
	nix run $(REBUILD) --extra-experimental-features 'nix-command flakes' -- switch --flake .#$(HOSTNAME)

.PHONY: update
update:
	nix flake update
	make os
	make home
	git restore --staged .
	git add flake.lock
	git commit --message 'chore: Update flake'
