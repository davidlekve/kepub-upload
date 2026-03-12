# Description: EPUB ebooks — converted via kepubify
# Extensions: .epub

convert_epub_check() {
  require_tool kepubify \
    "yay:yay -S kepubify-bin" \
    "paru:paru -S kepubify-bin" \
    "brew:brew install kepubify" \
    "unknown:https://github.com/pgaskin/kepubify/releases"
}

convert_epub() {
  local input="$1" dir="$2" stem="$3"

  log_info "Converting epub to kepub..."
  kepubify -o "$dir" "$input"

  KEPUB_FILE="$dir/${stem}.kepub.epub"
}
