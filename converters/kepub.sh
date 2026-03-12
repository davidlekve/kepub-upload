# Description: Kobo kepub — uploaded directly, no conversion
# Extensions: .kepub.epub

convert_kepub() {
  local input="$1"
  # No conversion needed
  KEPUB_FILE="$input"
  log_info "Already in kepub format, skipping conversion"
}
