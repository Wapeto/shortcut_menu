def NUL: "\u0000";
def US:  "\u001f";

def esc:
  gsub("&"; "&amp;")
  | gsub("<"; "&lt;")
  | gsub(">"; "&gt;");

def oneline:
  gsub("[\\r\\n\\t]+"; " ")
  | gsub("  +"; " ");

def clip($n):
  if length > $n then .[0:($n-1)] + "…" else . end;

def norm_plus:
  gsub("\\s*\\+\\s*"; " + ");

def key_label:
  ascii_downcase as $t
  | if   $t == "super" then "SUPER"
    elif $t == "shift" then "SHIFT"
    elif $t == "ctrl" or $t == "control" then "CTRL"
    elif $t == "alt" then "ALT"
    elif $t == "return" or $t == "enter" then "ENTER"
    elif $t == "escape" or $t == "esc" then "ESC"
    elif $t == "tab" then "TAB"
    elif $t == "space" then "SPACE"
    elif $t == "left" then "←"
    elif $t == "right" then "→"
    elif $t == "up" then "↑"
    elif $t == "down" then "↓"
    else . end;

def keycap:
  key_label
  | esc
  | "<span background=\"#232323\" foreground=\"#e6e6e6\"> " + . + " </span>";

def pretty_keys:
  (.keys | norm_plus)
  | split(" + ")
  | map(select(length > 0) | keycap)
  | join("<span foreground=\"#7a7a7a\"> + </span>");

select(.type != "header")
| (
    "<span foreground=\"#a8a8a8\">"
    + (.section | esc)
    + " · </span>"
    + "<b>" + (.desc | oneline | clip(70) | esc) + "</b>"
    + "    "
    + pretty_keys
  )
  + NUL
  + "info" + US + (.cmd | oneline)
  + US + "meta" + US + ((.section + " " + .keys + " " + .cmd) | oneline)