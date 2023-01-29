BEGIN {
    FS = "[,: {()]+"
    print "erDiagram";
}
# Clean up
{gsub(/^\s+/, "")}
/^(\/\/|@)/ {next}

# New entity
/^entity / {
    print "   ", toupper($2), "{"
    RS = ";|}\n"
}
RT == ";" {
    gsub("\n", "");
    if ($2 == "Association") {
        print "       ", $1, "--->", $4, $5
        next
    }
    print "       ", $1
}
RT == "}\n" {
    RS = "\n"
    print "    }"
}
