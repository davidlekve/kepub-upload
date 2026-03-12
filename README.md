# kepub-upload

Convert ebooks to Kobo's kepub format and upload to cloud storage via [rclone](https://rclone.org).

Supports epub, pdf, and kepub out of the box. New formats can be added by dropping a single file into `converters/`.

## Install

**curl** (any Linux/macOS):

```sh
curl -sL https://raw.githubusercontent.com/<user>/kepub-upload/main/install.sh | bash
```

**Arch Linux (AUR)**:

```sh
yay -S kepub-upload
```

**git clone**:

```sh
git clone https://github.com/<user>/kepub-upload
cd kepub-upload
make install PREFIX=~/.local
```

### Dependencies

| Tool | Required | Install (Arch) | Install (Debian/Ubuntu) | Install (macOS) |
|------|----------|----------------|------------------------|-----------------|
| [rclone](https://rclone.org) | Always | `pacman -S rclone` | `apt install rclone` | `brew install rclone` |
| [kepubify](https://github.com/pgaskin/kepubify) | epub/pdf input | `yay -S kepubify-bin` | [releases](https://github.com/pgaskin/kepubify/releases) | `brew install kepubify` |
| [calibre](https://calibre-ebook.com) | pdf input only | `pacman -S calibre` | `apt install calibre` | `brew install calibre` |

### rclone setup

If you haven't configured rclone yet:

```sh
rclone config
# Follow prompts to add a remote (e.g. "gdrive" for Google Drive)
```

## Usage

```sh
kepub-upload novel.epub              # convert + upload
kepub-upload textbook.pdf            # pdf → epub → kepub → upload
kepub-upload book.kepub.epub         # upload directly

kepub-upload -r dropbox novel.epub   # upload to a different remote
kepub-upload -p Books/Fiction n.epub # upload to a specific path
kepub-upload --dry-run novel.pdf     # convert only, don't upload
kepub-upload --keep novel.epub       # keep the .kepub.epub locally
```

## Configuration

Create `~/.config/kepub-upload/config`:

```sh
KEPUB_UPLOAD_REMOTE=gdrive
KEPUB_UPLOAD_PATH=Books/Kobo
```

CLI flags and environment variables override the config file.

| Variable | Default | Description |
|----------|---------|-------------|
| `KEPUB_UPLOAD_REMOTE` | `gdrive` | rclone remote name |
| `KEPUB_UPLOAD_PATH` | `Books/Kobo` | destination directory on remote |
| `KEPUB_UPLOAD_CONVERTERS_DIR` | (auto) | custom converters directory |

## Adding a new format

Create a file in `converters/`, e.g. `converters/mobi.sh`:

```sh
# Description: MOBI ebooks — converted via calibre + kepubify
# Extensions: .mobi

convert_mobi_check() {
  require_tool ebook-convert \
    "pacman:pacman -S calibre" \
    "apt:sudo apt install calibre"
  require_tool kepubify \
    "yay:yay -S kepubify-bin"
}

convert_mobi() {
  local input="$1" dir="$2" stem="$3"

  log_info "Converting mobi to epub..."
  local epub_file="$dir/${stem}.epub"
  ebook-convert "$input" "$epub_file"
  TEMP_FILES+=("$epub_file")

  log_info "Converting epub to kepub..."
  kepubify -o "$dir" "$epub_file"
  KEPUB_FILE="$dir/${stem}.kepub.epub"
}
```

That's it. No changes to the main script needed.

### Converter contract

Each converter file must:

1. Have `# Description:` and `# Extensions:` comment headers
2. Define `convert_<name>()` that sets `KEPUB_FILE` to the output path
3. Optionally define `convert_<name>_check()` to verify dependencies

The function receives three arguments: `$1` input file path, `$2` output directory, `$3` filename stem (without extension).

## Shell completions

Completions for bash, zsh, and fish are installed automatically by `make install`. If you installed manually:

```sh
# bash — add to ~/.bashrc
source /path/to/kepub-upload/completions/kepub-upload.bash

# zsh — add to ~/.zshrc (before compinit)
fpath=(/path/to/kepub-upload/completions $fpath)

# fish
cp completions/kepub-upload.fish ~/.config/fish/completions/
```

## License

[MIT](LICENSE)
