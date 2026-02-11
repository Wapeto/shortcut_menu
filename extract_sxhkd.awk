BEGIN {
    in_title_block = 0
    section = "General"
    desc = ""
    keys = ""
    cmd = ""

    emit_header(section)
}

function jesc(s, t) {
    t = s
    gsub(/\\/, "\\\\", t)
    gsub(/"/, "\\\"", t)
    gsub(/\t/, "\\t", t)
    gsub(/\n/, "\\n", t)
    gsub(/\r/, "\\r", t)
    return t
}

function emit_header(name) {
    if (name == "") return
    print "{\"type\": \"header\", \"text\": \"" jesc(name) "\"}"
}

function emit_entry(d) {
    if (keys == "" || cmd == "") return

    d = desc
    if (d == "") d = cmd

    print "{\"type\": \"entry\", \"section\": \"" jesc(section) \
        "\", \"desc\": \"" jesc(d) \
        "\", \"keys\": \"" jesc(keys) \
        "\", \"cmd\": \"" jesc(cmd) "\"}"

    desc = ""
    keys = ""
    cmd = ""
}

# Blank line indicates end of entry
/^[ \t]*$/ { emit_entry(); next }

# Lines with only # toggle title block
/^#[ \t]*$/ { in_title_block = !in_title_block; next }

# comment line
/^# / {
    if (in_title_block) {
        section = substr($0, 3)
        emit_header(section)
    } else {
        desc = substr($0, 3)
    }
    next
}

# command line
/^\t/ {
    if (keys != "") {
        if (cmd != "") cmd = cmd "\n"
        cmd = cmd substr($0, 2)
    }
    next
}

# keys line
/^[^# \t]/ { emit_entry(); keys = $0; next }