def NUL: "\u0000";
def US: "\u001F";

if .type == "header" then
    (.text)
    + NUL + "nonselectable" + US + "true"
    + US + "meta" + US + (.text)
else
    (.desc + "      " + .keys)
    + NUL
    + "info" + US + (.cmd)
    + US + "meta" + US + (.section + "   " + .keys + "   " + .cmd)
end