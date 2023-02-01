BEGIN {
    print "erDiagram"
}
/\<entity\>/, /};?$/ {
    gsub(/^\s+|\/\/.*$|localized|\([^)]+\)|;/, "")
    if ($1 == "entity") {print "   ", EntityName = $2, "{"; next}
    if ($3 == "Association") saveAssociation()
    if ($1 == "}") {print "    }\n"; next}
    if ($1 ~ /^@/) next
    if ($1 == "key" || $2 == ":") printAttribute()
}
END {
    for (relation in Associations) print "   ", Associations[relation]
}

function printAttribute(   key) {
    if ($1 == "key") {key = "PK"; gsub(/key/, "")}
    chopPrefix($3); print "       ", $3, $1, key
}

function saveAssociation(   relation,cardinality,target) {
    if ($5 ~ "one|many") {
        cardinality = $5
        target = 6
    } else {
        cardinality = "one"
        target = 5
    }
    chopPrefix(target)

    relation = "||--" (cardinality == "one" ? "o|" : "o{")
    Associations[$1] = EntityName" "relation" "$target" : "$1
    next
}

function chopPrefix(target) {
    sub(/.+\./, "", $target)
}
