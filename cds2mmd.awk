BEGIN {
    FS = "[,: {()]+"
    EndOfEntity = "}\n";
    EndOfAttribute = ";\n";

    print "erDiagram";
}
# Clean up
{gsub(/^\s+/, "")}
/^(\/\/|@)/ {next}

/^entity / {
    RS = EndOfAttribute "|" EndOfEntity
    delete Associations
    EntityName = $2
    print ""
    print "   ", EntityName, "{"
}

RT == EndOfAttribute {
    processRecord()
}

RT == EndOfEntity {
    processRecord()
    processEntity()
}

function processRecord() {
    gsub("\n", "");
    if (NF < 2) return

    if ($2 == "Association") {
        saveAssociation()
    } else {
        printAttribute()
    }
}

function printAttribute(   key,attribute,typeIndex) {
    key = $1 == "key" ? "PK" : ""
    attribute = key ? $2 : $1
    typeIndex = key ? 3 : 2
    typeIndex += $typeIndex == "localized" ? 1 : 0
    print "       ", tolower($typeIndex), attribute, key
}

function processEntity(   relation) {
    RS = "\n"
    print "    }"
    for (relation in Associations) {
        print "   ", Associations[relation]
    }
}

function saveAssociation(   relation,target) {
    target = $NF
    sub(/.+\./, "", target)

    relation = "||--||"
    Associations[$1] = EntityName" "relation" "target" : "$1
}