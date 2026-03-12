PREFIX  ?= /usr/local
DESTDIR ?=

BINDIR  = $(DESTDIR)$(PREFIX)/bin
DATADIR = $(DESTDIR)$(PREFIX)/share/kepub-upload
COMPDIR_BASH = $(DESTDIR)$(PREFIX)/share/bash-completion/completions
COMPDIR_ZSH  = $(DESTDIR)$(PREFIX)/share/zsh/site-functions
COMPDIR_FISH = $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d

.PHONY: install uninstall lint test

install:
	@echo "Installing kepub-upload to $(PREFIX)..."
	install -d "$(BINDIR)"
	install -d "$(DATADIR)/converters"
	install -m 755 kepub-upload "$(DATADIR)/kepub-upload"
	install -m 644 converters/*.sh "$(DATADIR)/converters/"
	ln -sf "$(PREFIX)/share/kepub-upload/kepub-upload" "$(BINDIR)/kepub-upload"
	@# Completions
	install -d "$(COMPDIR_BASH)"
	install -m 644 completions/kepub-upload.bash "$(COMPDIR_BASH)/kepub-upload"
	install -d "$(COMPDIR_ZSH)"
	install -m 644 completions/kepub-upload.zsh "$(COMPDIR_ZSH)/_kepub-upload"
	install -d "$(COMPDIR_FISH)"
	install -m 644 completions/kepub-upload.fish "$(COMPDIR_FISH)/kepub-upload.fish"
	@echo "Installed."

uninstall:
	@echo "Uninstalling kepub-upload..."
	rm -f  "$(BINDIR)/kepub-upload"
	rm -rf "$(DATADIR)"
	rm -f  "$(COMPDIR_BASH)/kepub-upload"
	rm -f  "$(COMPDIR_ZSH)/_kepub-upload"
	rm -f  "$(COMPDIR_FISH)/kepub-upload.fish"
	@echo "Uninstalled."

lint:
	shellcheck kepub-upload converters/*.sh

test:
	bats tests/
