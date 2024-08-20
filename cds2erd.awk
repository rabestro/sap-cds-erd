#!/usr/bin/gawk --exec
#
# Copyright (c) 2023 Jegors Čemisovs
# License: Apache-2.0 license
# Repository: https://github.com/rabestro/sap-cds-erd-mermaid
#
# Creates ERDs for SAP Cloud Application Programming Model
#
BEGIN {
    FS = "[,: {()]+"
    print "erDiagram"
}
/^\s*\/\*/, /.*\*\// {next}     # skips multiline comments
/^\s*(@|on |and )/ {next}       # skip annotations and joins
/\<entity\>/, /};?$/ {
    cleanUp()
    if ($1 == "entity") printEntity()
    else if ($2 ~ "Association|Composition") saveAssociation()
    else if ($1 == "key") printRecord($3, $2, "PK")
    else if (NF > 1) printRecord($2, $1)
    else if ($1 == "}") print "    }\n"
}
END {
    for (sourceEntity in Associations) {
        for (targetEntity in Associations[sourceEntity]) {
            left = Associations[sourceEntity][targetEntity][1]
            right = Associations[sourceEntity][targetEntity][2]
            relation = (left?left:"|o")"--"(right?right:"o|")
            print "   ", sourceEntity, relation, targetEntity, ": \"\""
        }
    }
}
function printEntity() {
    print "   ", EntityName = $2, "{"
    if ($0 ~ /CodeList/) {
        printRecord("String", "name")
        printRecord("String", "descr")
    }
}
function printRecord(type, attribute, key) {
    print "       ", type, attribute, key
}
function saveAssociation(   cardinality,targetEntity,mandatory) {
    if ($4 ~ "one|many") {
        cardinality = $4
        targetEntity = $5
    } else {
        cardinality = "one"
        targetEntity = $4
    }
    mandatory = $0 ~ /not null|@mandatory/ ? "|" : "o"

    if (targetEntity in Associations && EntityName in Associations[targetEntity]) {
        Associations[targetEntity][EntityName][1] = (cardinality == "one" ? "|" : "}") mandatory
    } else {
        Associations[EntityName][targetEntity][2] = mandatory (cardinality == "one" ? "|" : "{")
    }
}
function cleanUp() {
    gsub(/^\s+|\/\/.*$|localized|\([^)]+\)|;|\<[[:alpha:]]{1,4}\.|@[[:alpha:]]+;?/, "")
}
