#!/usr/bin/env bats

load test_helper

@test "epub: calls kepubify and sets KEPUB_FILE" {
  create_mock kepubify '
    outdir="."
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -o) outdir="$2"; shift 2 ;;
        *)  input="$1"; shift ;;
      esac
    done
    stem="$(basename "$input" .epub)"
    touch "$outdir/${stem}.kepub.epub"
  '
  create_mock rclone 'exit 0'

  touch "$TEMP_DIR/novel.epub"

  run "$KEPUB_UPLOAD" --dry-run "$TEMP_DIR/novel.epub"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Converting epub to kepub"* ]]
  [[ "$output" == *"novel.kepub.epub"* ]]
}

@test "kepub: uploads directly without conversion" {
  create_mock rclone 'exit 0'
  touch "$TEMP_DIR/novel.kepub.epub"

  run "$KEPUB_UPLOAD" --dry-run "$TEMP_DIR/novel.kepub.epub"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Already in kepub format"* ]]
}

@test "pdf: calls ebook-convert then kepubify" {
  create_mock ebook-convert 'touch "$2"'
  create_mock kepubify '
    outdir="."
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -o) outdir="$2"; shift 2 ;;
        *)  input="$1"; shift ;;
      esac
    done
    stem="$(basename "$input" .epub)"
    touch "$outdir/${stem}.kepub.epub"
  '
  create_mock rclone 'exit 0'

  touch "$TEMP_DIR/textbook.pdf"

  run "$KEPUB_UPLOAD" --dry-run "$TEMP_DIR/textbook.pdf"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Converting pdf to epub"* ]]
  [[ "$output" == *"Converting epub to kepub"* ]]
}

@test "--keep prevents cleanup of converted files" {
  create_mock kepubify '
    outdir="."
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -o) outdir="$2"; shift 2 ;;
        *)  input="$1"; shift ;;
      esac
    done
    stem="$(basename "$input" .epub)"
    touch "$outdir/${stem}.kepub.epub"
  '
  create_mock rclone 'exit 0'

  touch "$TEMP_DIR/novel.epub"

  run "$KEPUB_UPLOAD" --dry-run --keep "$TEMP_DIR/novel.epub"
  [ "$status" -eq 0 ]
  [ -f "$TEMP_DIR/novel.kepub.epub" ]
}

@test "handles filenames with spaces and special characters" {
  create_mock kepubify '
    outdir="."
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -o) outdir="$2"; shift 2 ;;
        *)  input="$1"; shift ;;
      esac
    done
    stem="$(basename "$input" .epub)"
    touch "$outdir/${stem}.kepub.epub"
  '
  create_mock rclone 'exit 0'

  touch "$TEMP_DIR/A Book's Title (2024).epub"

  run "$KEPUB_UPLOAD" --dry-run "$TEMP_DIR/A Book's Title (2024).epub"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Converting epub to kepub"* ]]
}
