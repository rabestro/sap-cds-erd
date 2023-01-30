BEGIN {
    FS = "[,: {()]+"
    EndOfEntity = "};?\n";
    EndOfAttribute = ";\n";

    print "erDiagram";
}
# Clean up
{gsub(/^\s+/, "")}
/^@/ {next}

/^entity / {
    RS = EndOfEntity "|" EndOfAttribute
    delete Associations
    EntityName = $2
    print ""
    print "   ", EntityName, "{"
}

RT == EndOfAttribute {
    processRecord()
}

isEntityEnd() {
    processRecord()
    processEntity()
}

function isEntityEnd() {
    return substr(RT, 1, 1)  == "}"
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
    RS = "\n"
    print "    }"
    for (relation in Associations) {
        print "   ", Associations[relation]
    }
}

function saveAssociation(   relation,cardinality,target) {
    cardinality = NF == 4 ? "one" : $4
    target = NF == 4 ? 4 : 5
    chopPrefix(target)

    relation = "||--" (cardinality == "one" ? "||" : "|{")
    Associations[$1] = EntityName" "relation" "$target" : "$1
}

function chopPrefix(target) {
    sub(/.+\./, "", $target)
}