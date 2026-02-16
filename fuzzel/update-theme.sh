#!/usr/bin/env bash
# Paths
WAL_COLORS="$HOME/.cache/wal/colors-fuzzel.ini"
FUZZEL_BASE="$HOME/.config/fuzzel/base.ini"
FUZZEL_FINAL="$HOME/.config/fuzzel/fuzzel.ini"

# Check if pywal colors exist
if [[ ! -f "$WAL_COLORS" ]]; then
    echo "❌ Pywal colors file not found: $WAL_COLORS"
    exit 1
fi

# Set your preferred transparency here (hex alpha, lower = more transparent)
#   80 ≈ 50% see-through (good start for seeing wallpaper)
#   b0 ≈ 69% opaque (subtle)
#   cc ≈ 80% opaque (slight)
#   60 ≈ 37% opaque (more transparent)
ALPHA="b0"

# Extract pywal's background RGB (strip the old ff alpha)
PYWAL_BG=$(grep '^background=' "$WAL_COLORS" | cut -d'=' -f2 | sed 's/..$//')

if [[ -z "$PYWAL_BG" ]]; then
    echo "⚠️ Could not find background in pywal file — using fallback"
    PYWAL_BG="090404"  # your current dark color
fi

# Build final config
{
    cat "$FUZZEL_BASE"
    echo ""  # spacing
    echo "[colors]"
    echo "background=${PYWAL_BG}${ALPHA}"
    # Include all other pywal colors, skipping the original background
    grep -v '^background=' "$WAL_COLORS"
} > "$FUZZEL_FINAL"

echo "✅ Fuzzel updated: background now ${PYWAL_BG}${ALPHA} (alpha=${ALPHA})"
