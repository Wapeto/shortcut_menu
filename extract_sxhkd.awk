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
    gsub(/\\/,"\\\\",t)
    gsub(/"/,"\\\"",t)
    gsub(/\t/,"\\t",t)
    gsub(/\r/,"\\r",t)
    gsub(/\n/,"\\n",t)
    return t
}

function emit_header(name) {
    if (name == "") return
    print "{\"type\":\"header\",\"text\":\"" jesc(name) "\"}"
}

function emit_entry(d) {
    if (keys == "" || cmd == "") return

    d = desc
    if (d == "") d = cmd

    print "{\"type\":\"entry\",\"section\":\"" jesc(section) \
          "\",\"desc\":\"" jesc(d) \
          "\",\"keys\":\"" jesc(keys) \
          "\",\"cmd\":\"" jesc(cmd) "\"}"

    desc = ""
    keys = ""
    cmd = ""
}

/^[ \t]*$/ { emit_entry(); next }
/^#[ \t]*$/ { in_title_block = !in_title_block; next }

/^# / {
    if (in_title_block) {
        section = substr($0, 3)
        emit_header(section)
    } else {
        desc = substr($0, 3)
    }
    next
}

/^\t/ {
    if (keys != "") {
        # IMPORTANT: join command lines into ONE LINE so rofi never breaks rows
        if (cmd != "") cmd = cmd " ; "
        cmd = cmd substr($0, 2)
    }
    next
}

/^[^# \t]/ { emit_entry(); keys = $0; next }

END { emit_entry() }
