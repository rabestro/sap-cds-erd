BEGIN {
    FS = "[,: {()]+"
    print "erDiagram"
}
/^\s*(@|on )/{next}
/\<entity\>/, /};?$/ {
    gsub(/^\s+|\/\/.*$|localized|\([^)]+\)|;|\<[[:alpha:]]{1,4}\.|@[[:alpha:]]+;?/, "")
    if ($1 == "entity") printEntity()
    if ($2 ~ "Association|Composition") saveAssociation()
    if ($1 == "key") {printRecord($3, $2, "PK"); next}
    if (NF > 1) {printRecord($2, $1); next}
    if ($1 == "}") print "    }\n"
}
END {
    for (sourceEntity in Associations) {
        for (targetEntity in Associations[sourceEntity]) {
            left = Associations[sourceEntity][targetEntity][1]
            right = Associations[sourceEntity][targetEntity][2]
            relation = (left?left:"|o")"--"(right?right:"o|")
            print "   ", sourceEntity, relation, targetEntity, ":\"\""
        }
    }
}

function printEntity() {
    print "   ", EntityName = $2, "{"
    if ($0 ~ /CodeList/) {
        printRecord("String", "name")
        printRecord("String", "descr")
    }
    next
}

function printRecord(type, attribute, key) {
    print "       ", type, attribute, key
}

function saveAssociation(   cardinality,targetEntity) {
    if ($4 ~ "one|many") {
        cardinality = $4
        targetEntity = $5
    } else {
        cardinality = "one"
        targetEntity = $4
    }
    if (targetEntity in Associations && EntityName in Associations[targetEntity]) {
        Associations[targetEntity][EntityName][1] = cardinality == "one" ? "|o" : "}o"
    } else {
        Associations[EntityName][targetEntity][2] = cardinality == "one" ? "o|" : "o{"
    }
    next
}
