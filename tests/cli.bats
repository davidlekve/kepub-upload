#!/usr/bin/env bats

load test_helper

@test "--version prints version" {
  run "$KEPUB_UPLOAD" --version
  [ "$status" -eq 0 ]
  [[ "$output" == "kepub-upload "* ]]
}

@test "--help shows usage and exits 0" {
  run "$KEPUB_UPLOAD" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"USAGE"* ]]
  [[ "$output" == *"OPTIONS"* ]]
}

@test "no arguments shows usage and exits 2" {
  run "$KEPUB_UPLOAD"
  [ "$status" -eq 2 ]
  [[ "$output" == *"USAGE"* ]]
}

@test "unknown option shows error and exits 2" {
  run "$KEPUB_UPLOAD" --bad-flag
  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown option"* ]]
}

@test "--remote without argument shows error" {
  run "$KEPUB_UPLOAD" --remote
  [ "$status" -eq 2 ]
  [[ "$output" == *"requires an argument"* ]]
}

@test "--path without argument shows error" {
  run "$KEPUB_UPLOAD" --path
  [ "$status" -eq 2 ]
  [[ "$output" == *"requires an argument"* ]]
}

@test "missing file shows error" {
  run "$KEPUB_UPLOAD" nonexistent.epub
  [ "$status" -eq 1 ]
  [[ "$output" == *"File not found"* ]]
}

@test "--list-formats shows available formats" {
  run "$KEPUB_UPLOAD" --list-formats
  [ "$status" -eq 0 ]
  [[ "$output" == *"epub"* ]]
  [[ "$output" == *"pdf"* ]]
  [[ "$output" == *"kepub"* ]]
}

@test "unsupported file extension shows error" {
  touch "$TEMP_DIR/book.docx"
  run "$KEPUB_UPLOAD" "$TEMP_DIR/book.docx"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported format"* ]]
}
