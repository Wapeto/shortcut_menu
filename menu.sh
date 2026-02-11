#!/bin/sh

awk '
BEGIN {
    OFS = "->"
    start = 0
    title = ""
    description = ""
    shortcut = ""
    command = ""
    com_text = "^# [[:alnum:]_]+"
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
    # print title
    title = ""
    next
}
/^\t/ {
    if (shortcut) {
        command = substr($0, 2)
        print description
        print shortcut
        print command
    }
    description = ""
    shortcut = ""
    command = ""
}
$0 ~ com_text {
    if (start) {
        title = substr($0, 3)
    } else {
        description = $0
    }
    shortcut = ""
    next
}
/^[[:alnum:]_]+/ {
    shortcut = $0
}

' "$HOME/.config/sxhkd/sxhkdrc"
