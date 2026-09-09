# Dotfiles installer.
#
# Installation links, it does not copy. A copy is one-directional: an edit made
# live is invisible to git and is destroyed by the next install. That is what
# caused four months of silent drift. With links, `git status` tells the truth.
#
# Usage on a new machine:
#   make backup && make link && make doctor
#
# PRIVATE is the private config repo. Override it if yours lives elsewhere.

REPO    := $(shell pwd)
PRIVATE ?= $(HOME)/workspace/personal/dotfiles-private
STAMP   := $(shell date +%Y%m%d-%H%M%S)
BACKUP  := $(HOME)/dotfiles-backups/$(STAMP)

# Link targets, as "live path:repo path" pairs.
# Directories are linked whole where the whole directory is ours (nvim, kitty).
# Individual files are linked where the directory is shared (~, ~/.claude).
PUBLIC_LINKS := \
	$(HOME)/.zshrc:$(REPO)/zsh/.zshrc \
	$(HOME)/.p10k.zsh:$(REPO)/zsh/.p10k.zsh \
	$(HOME)/.tmux.conf:$(REPO)/tmux/.tmux.conf \
	$(HOME)/.visidatarc:$(REPO)/visidata/.visidatarc \
	$(HOME)/.config/kitty:$(REPO)/kitty \
	$(HOME)/.config/nvim:$(REPO)/nvim \
	$(HOME)/.claude/bin:$(REPO)/claude/bin

PRIVATE_LINKS := \
	$(HOME)/.zshrc_private:$(PRIVATE)/zsh/.zshrc_private \
	$(HOME)/.claude/settings.json:$(PRIVATE)/claude/settings.json \
	$(HOME)/.claude/CLAUDE.md:$(PRIVATE)/claude/CLAUDE.md \
	$(HOME)/.claude/statusline-command.sh:$(PRIVATE)/claude/statusline-command.sh \
	$(HOME)/.claude/hooks:$(PRIVATE)/claude/hooks

ALL_LINKS := $(PUBLIC_LINKS) $(PRIVATE_LINKS)

.PHONY: help backup link link-public link-private unlink doctor brew-dump

help:
	@echo "backup   copy every path install would touch to $(HOME)/dotfiles-backups/<stamp>"
	@echo "link     link public and private config into place (run backup first)"
	@echo "unlink   remove only the links this Makefile made"
	@echo "doctor   report drift: real files where links are expected, and dangling links"
	@echo "brew-dump  refresh the Brewfile from the current machine"

# The first link run replaces live files. This is not optional.
backup:
	@mkdir -p "$(BACKUP)"
	@for pair in $(ALL_LINKS); do \
		live="$${pair%%:*}"; \
		if [ -e "$$live" ] && [ ! -L "$$live" ]; then \
			dest="$(BACKUP)/$$(echo "$${live#$(HOME)/}" | tr / _)"; \
			cp -a "$$live" "$$dest"; \
			echo "backed up $$live"; \
		fi; \
	done
	@echo "backup at $(BACKUP)"

link: link-public link-private

link-public:
	@$(MAKE) --no-print-directory _link PAIRS="$(PUBLIC_LINKS)"

link-private:
	@if [ ! -d "$(PRIVATE)" ]; then \
		echo "private repo not found at $(PRIVATE); set PRIVATE=<path>"; exit 1; \
	fi
	@$(MAKE) --no-print-directory _link PAIRS="$(PRIVATE_LINKS)"

_link:
	@for pair in $(PAIRS); do \
		live="$${pair%%:*}"; repo="$${pair#*:}"; \
		if [ ! -e "$$repo" ]; then echo "SKIP  $$live (no $$repo)"; continue; fi; \
		mkdir -p "$$(dirname "$$live")"; \
		if [ -L "$$live" ] && [ "$$(readlink "$$live")" = "$$repo" ]; then \
			echo "ok    $$live"; continue; \
		fi; \
		rm -rf "$$live"; \
		ln -s "$$repo" "$$live"; \
		echo "link  $$live -> $$repo"; \
	done

unlink:
	@for pair in $(ALL_LINKS); do \
		live="$${pair%%:*}"; repo="$${pair#*:}"; \
		if [ -L "$$live" ] && [ "$$(readlink "$$live")" = "$$repo" ]; then \
			rm "$$live"; echo "removed $$live"; \
		fi; \
	done
	@echo "live paths are now absent; restore from a backup or run make link"

# How drift gets caught next time.
doctor:
	@fail=0; \
	for pair in $(ALL_LINKS); do \
		live="$${pair%%:*}"; repo="$${pair#*:}"; \
		if [ ! -e "$$repo" ]; then printf 'MISSING  %s (repo file absent)\n' "$$live"; fail=1; \
		elif [ -L "$$live" ]; then \
			if [ "$$(readlink "$$live")" = "$$repo" ]; then printf 'ok       %s\n' "$$live"; \
			else printf 'WRONG    %s -> %s\n' "$$live" "$$(readlink "$$live")"; fail=1; fi; \
		elif [ -e "$$live" ]; then printf 'DRIFT    %s is a real file, not a link\n' "$$live"; fail=1; \
		else printf 'ABSENT   %s\n' "$$live"; fail=1; fi; \
	done; \
	exit $$fail

brew-dump:
	brew bundle dump --force --file=Brewfile
