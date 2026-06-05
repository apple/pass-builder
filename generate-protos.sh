#!/usr/bin/env bash
# generate-protos.sh
# Compiles all .proto definitions into Swift and writes them to the output directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROTO_DIR="$SCRIPT_DIR/Protobufs"
OUTPUT_DIR="$SCRIPT_DIR/Sources/PassBuilder/TemplatePersonalization/Protobuf"

# ── Validate tooling ──────────────────────────────────────────────────────────
if ! command -v protoc &>/dev/null; then
  echo "❌  protoc not found. Install with: brew install protobuf" >&2
  exit 1
fi

if ! command -v protoc-gen-swift &>/dev/null; then
  echo "❌  protoc-gen-swift not found. Install with: brew install swift-protobuf" >&2
  exit 1
fi

# ── Prepare output directory ──────────────────────────────────────────────────
echo "🗑️   Cleaning output directory..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# ── Compile ───────────────────────────────────────────────────────────────────
PROTO_FILES=("$PROTO_DIR"/*.proto)

if [[ ${#PROTO_FILES[@]} -eq 0 ]]; then
  echo "⚠️   No .proto files found in $PROTO_DIR" >&2
  exit 1
fi

echo "⚙️   Compiling ${#PROTO_FILES[@]} .proto file(s) → Swift..."

protoc \
  --proto_path="$PROTO_DIR" \
  --swift_out="$OUTPUT_DIR" \
  "${PROTO_FILES[@]}"

# ── Summary ───────────────────────────────────────────────────────────────────
GENERATED=$(find "$OUTPUT_DIR" -name "*.swift" | wc -l | tr -d ' ')
echo "✅  Done — $GENERATED Swift file(s) written to:"
echo "    $OUTPUT_DIR"
