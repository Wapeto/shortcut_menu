#!/bin/sh

emit_headers() {
    printf '\000markup-rows\037true\n'
    printf '\000prompt\037Shortcuts\n'
    printf '\000message\037Select a shortcut\n'
}


emit_rows() {
        awk '
        BEGIN {
            OFS = "->"
            nul = sprintf("%c", 0)
            us = sprintf("%c", 31)
            start = 0
            title = ""
            description = ""
            shortcut = ""
            command = ""
            com_text = "^# [[:alnum:]_]+"
        }
        function display_row(){
            if (!description) {
                description = command
            }
            # printf("%s->%s\0info\x1f%s\x1fmeta\x1f%s\n", description, shortcut, command, description)
            print description,shortcut nul "info" us command us "meta" us description
        }
        function reset() {
            description = ""
            shortcut = ""
            command = ""
        }
        /^[ \t]*$/ {
            if (command && shortcut) {
                display_row()
            }
            reset()
            next
        }
        /^#[ \t]*$/ {
            if (start) {
                start = 0
            } else {
                start = 1
            }
            shortcut = ""
            next
        }
        title {
            print title nul "nonselectable" us "true"
            title = ""
        }
        /^\t/ {
            if (shortcut) {
                if (command) {
                    command = command ";" substr($0, 2)
                } else {
                    command = substr($0, 2)
                }
            } else {
                reset()
            }
        }
        $0 ~ com_text {
            if (start) {
                title = substr($0, 3)
            } else {
                description = substr($0, 3)
            }
            shortcut = ""
            next
        }
        /^[^# \t]/ {
            shortcut = $0
        }

        ' "$HOME/.config/sxhkd/sxhkdrc"
}


case "$ROFI_RETV" in 
    0) {
        emit_headers
        emit_rows
    }
esac
