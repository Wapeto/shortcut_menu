#!/bin/sh

SXHKDRC="${SXHKDRC:-$HOME/.config/sxhkd/sxhkdrc}"
AWK_EXTRACT="${AWK_EXTRACT:-./extract_sxhkd.awk}"
JQ_RENDER="${JQ_RENDER:-./render_rofi.jq}"

emit_headers() {
    printf '\000markup-rows\037true\n'
    printf '\000prompt\037Shortcuts\n'
    printf '\000message\037Select a shortcut\n'
}

emit_rows() {
    awk -f "$AWK_EXTRACT" "$SXHKDRC" | jq -r -f "$JQ_RENDER"
}

handle_selection() {
    [ -n "$ROFI_INFO" ] && printf "%s\n" "$ROFI_INFO"
}

case "$ROFI_RETV" in
    0) emit_headers; emit_rows ;;
    1) handle_selection ;;
esac