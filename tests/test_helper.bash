# Common test setup

setup() {
  export TEMP_DIR
  TEMP_DIR="$(mktemp -d)"

  # Create mock converters dir with the real converters
  export KEPUB_UPLOAD_CONVERTERS_DIR
  KEPUB_UPLOAD_CONVERTERS_DIR="$BATS_TEST_DIRNAME/../converters"

  # Put mock tools on PATH
  export MOCK_BIN="$TEMP_DIR/mock-bin"
  mkdir -p "$MOCK_BIN"
  export PATH="$MOCK_BIN:$PATH"

  # Disable colors in tests
  export NO_COLOR=1

  # Script under test
  export KEPUB_UPLOAD="$BATS_TEST_DIRNAME/../kepub-upload"
}

teardown() {
  rm -rf "$TEMP_DIR"
}

# Create a mock tool that creates expected output files
create_mock() {
  local name="$1"
  local script="${2:-exit 0}"
  printf '#!/usr/bin/env bash\n%s\n' "$script" > "$MOCK_BIN/$name"
  chmod +x "$MOCK_BIN/$name"
}
