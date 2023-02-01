BEGIN {
    FS = "[,: {()]+"
    EndOfEntity = "};?\n"
    EndOfAttribute = ";\n"

    print "erDiagram"
}

BEGINFILE {
#    print "    %%", FILENAME
}

# Clean up
{gsub(/^\s+/, "")}
/^@/ {next}

/\<entity\>/ {
    processEntityStart()
}

association() {
    saveAssociation()
}

RT == EndOfAttribute {
    processRecord()
}

isEntityEnd() {
    processRecord()

    print "    }\n"
    RS = "\n"
}

END {
    for (relation in Associations) {
        print "   ", Associations[relation]
    }
}

function processEntityStart() {
    EntityName = $2
    print "   ", EntityName, "{"
    RS = EndOfEntity "|" EndOfAttribute
}

function isEntityEnd() {
    return substr(RT, 1, 1)  == "}"
}

function association() {
    return RT == EndOfAttribute && $2 == "Association"
}

function processRecord() {
    gsub("(//[^\n]*)?\n *", " ")

    if (NF < 2) return

    if ($2 == "Association") {
        saveAssociation()
    } else {
        printAttribute()
    }
}

function printAttribute(   key,attrIndex) {
    key = $1 == "key" ? "PK" : ""
    attrIndex = key || !$1 ? 2 : 1
    print "       ", getType(attrIndex), $attrIndex, key
}

function getType(attrIndex,   typeIndex) {
    typeIndex = attrIndex + 1
    typeIndex += $typeIndex == "localized" ? 1 : 0
    chopPrefix(typeIndex)
    return tolower($typeIndex)
}

function processEntity(   relation) {
    print "    }"
    for (relation in Associations) {
        print "   ", Associations[relation]
    }
}

function saveAssociation(   relation,cardinality,target) {
    if ($4 ~ "one|many") {
        cardinality = $4
        target = 5
    } else {
        cardinality = "one"
        target = 4
    }
    chopPrefix(target)

    relation = "||--" (cardinality == "one" ? "|o" : "o{")
    Associations[$1] = EntityName" "relation" "$target" : "$1
}

function chopPrefix(target) {
    sub(/.+\./, "", $target)
}
