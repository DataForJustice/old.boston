#!/bin/sh -e

mdbfn=$1
schemafn=$2
fkfn=$3
datafn=$4
schema=$5

tf="temp.tf"

pre=""
[ -n "${schema}" ] && pre="\"${schema}\"."

mdb-schema "${mdbfn}" postgres > "${tf}"

# Schema file
echo "BEGIN;\n" > "${schemafn}"

sp=""
[ -n "${schema}" ] && echo "CREATE SCHEMA \"${schema}\";\n" >> "${schemafn}"
[ -n "${schema}" ] && sp="SET search_path = \"${schema}\", pg_catalog;\n" 

echo ${sp} >> "${schemafn}"

awk '($0 !~ /^ALTER TABLE.*FOREIGN KEY.*REFERENCES/) {print;}' "${tf}" >> "${schemafn}"

echo "\nEND;" >> "${schemafn}"

# Foreign keys file
echo "BEGIN;\n" > "${fkfn}"
echo ${sp} >> "${fkfn}"

awk '($0 ~ /^ALTER TABLE.*FOREIGN KEY.*REFERENCES/) {print;}' "${tf}" >> "${fkfn}"

echo "\nEND;" >> "${fkfn}"

# Data file
echo "BEGIN;\n" > "${datafn}"
echo "SET CONSTRAINTS ALL DEFERRED;\n" >> "${datafn}"

mdb-tables -1 "${mdbfn}" | while read TT
do
    mdb-export -Q -d '\t' -D '%Y-%m-%d %H:%M:%S' "${mdbfn}" "$TT" > "${tf}"

    awk -v pre="${pre}" -v TT="${TT}" \
	'(NR==1) {gsub(/\t/,"\",\""); print "COPY " pre "\"" TT "\"(\"" $0 "\") FROM stdin;";}' "${tf}" >> "${datafn}"
    awk '(NR>1) {gsub(/\t\t/,"\t\\N\t"); gsub(/\t$/,"\t\\N"); gsub(/\t\t/,"\t\\N\t"); print;}' "${tf}" >> "${datafn}"

    echo "\\.\n" >> "${datafn}"
done

echo "END;" >> "${datafn}"

rm -f "${tf}"
