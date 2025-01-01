#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CPP_DIR="$ROOT_DIR/cpp-engine"
CPP_BUILD_DIR="$CPP_DIR/target/release"
UI_LIBS_DIR="$ROOT_DIR/TicTacToeUI/TicTacToeUI/libs"
XCODE_PROJECT="$ROOT_DIR/TicTacToeUI/TicTacToeUI.xcodeproj"
XCODE_SCHEME="TicTacToeUI"

printf "\n==> Building C++ static library\n"
cmake -S "$CPP_DIR" -B "$CPP_BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
cmake --build "$CPP_BUILD_DIR" --config Release

printf "\n==> Copying C++ artifacts into SwiftUI libs folder\n"
cp "$CPP_BUILD_DIR/libtictactoe.a" "$UI_LIBS_DIR/libtictactoe.a"
cp "$CPP_DIR/src/tictactoe_c_api.h" "$UI_LIBS_DIR/tictactoe_c_api.h"

printf "\n==> Building Xcode project\n"
xcodebuild -project "$XCODE_PROJECT" \
  -scheme "$XCODE_SCHEME" \
  -configuration Debug \
  -destination 'platform=macOS' \
  build

if [[ "${1:-}" == "--run" ]]; then
  printf "\n==> Launching app\n"
  BUILD_SETTINGS="$(xcodebuild -project "$XCODE_PROJECT" -scheme "$XCODE_SCHEME" -configuration Debug -destination 'platform=macOS' -showBuildSettings)"
  BUILT_PRODUCTS_DIR="$(printf "%s\n" "$BUILD_SETTINGS" | awk -F' = ' '/BUILT_PRODUCTS_DIR/{print $2; exit}')"
  EXECUTABLE_PATH="$(printf "%s\n" "$BUILD_SETTINGS" | awk -F' = ' '/EXECUTABLE_PATH/{print $2; exit}')"

  APP_EXEC="$BUILT_PRODUCTS_DIR/$EXECUTABLE_PATH"
  if [[ -x "$APP_EXEC" ]]; then
    "$APP_EXEC" >/dev/null 2>&1 &
    printf "Started: %s\n" "$APP_EXEC"
  else
    printf "App executable not found: %s\n" "$APP_EXEC" >&2
    exit 1
  fi
fi

printf "\nDone.\n"
