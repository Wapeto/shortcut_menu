def NUL: "\u0000";
def US: "\u001F";
def esc:
  gsub("&"; "&amp;")
  | gsub("<"; "&lt;")
  | gsub(">"; "&gt;");

if .type == "header" then
  (
    "<span size=\"large\"><b>"
    + (.text | esc)
    + "</b></span>"
  )
  + NUL + "nonselectable" + US + "true"
  + US + "meta" + US + (.text)
else
  (
    "<b>" + (.desc | esc) + "</b>"
    + "    "
    + "<span foreground=\"#888888\">[ "
    + (.keys | esc)
    + " ]</span>"
  )
  + NUL
  + "info" + US + .cmd
  + US + "meta" + US + (.section + " " + .keys + " " + .cmd)
end