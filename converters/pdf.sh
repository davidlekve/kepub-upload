# Description: PDF documents — converted via calibre + kepubify
# Extensions: .pdf

convert_pdf_check() {
  require_tool ebook-convert \
    "pacman:pacman -S calibre" \
    "apt:sudo apt install calibre" \
    "brew:brew install calibre" \
    "dnf:sudo dnf install calibre" \
    "unknown:https://calibre-ebook.com/download"

  require_tool kepubify \
    "yay:yay -S kepubify-bin" \
    "paru:paru -S kepubify-bin" \
    "brew:brew install kepubify" \
    "unknown:https://github.com/pgaskin/kepubify/releases"
}

convert_pdf() {
  local input="$1" dir="$2" stem="$3"

  log_info "Converting pdf to epub (calibre)..."
  local epub_file="$dir/${stem}.epub"
  ebook-convert "$input" "$epub_file"
  TEMP_FILES+=("$epub_file")
  log_success "Converted to epub"

  log_info "Converting epub to kepub..."
  KEPUB_FILE="$dir/${stem}.kepub.epub"
  kepubify -o "$KEPUB_FILE" "$epub_file"
}
