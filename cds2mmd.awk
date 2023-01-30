BEGIN {
    FS = "[,: {()]+"
    print "erDiagram";
    EndOfEntity = "}\n";
    EndOfProperty = ";\n";
}
# Clean up
{gsub(/^\s+/, "")}
/^(\/\/|@)/ {next}

/^entity / {
    print "   ", toupper($2), "{"
    RS = EndOfProperty "|" EndOfEntity
}

RT == EndOfProperty {
    gsub("\n", "");
    if ($2 == "Association") {
        print "       ", $1, "--->", $4, $5
        next
    }
    print "       ", $1
}

RT == EndOfEntity {
    RS = "\n"
    print "    }"
}
