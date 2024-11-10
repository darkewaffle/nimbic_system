import std/[algorithm, json, paths, streams, strutils, tables]

import ../../neverwinterdotnim/neverwinter/[compressedbuf, gff]

#These are procedures or code-converted-to-procedures taken directly from nwn_gff.nim
proc postProcessJson*(j: JsonNode)
proc ExtractSqliteFromGFF*(GFFInput: GffRoot, SqliteLocation: Path)
proc PackSqliteIntoGFF*(GFFTarget: GffRoot, SqliteLocation: Path)


#Procedure copied as is and set for export with *.
proc postProcessJson*(j: JsonNode) =
    ## Post-process json before emitting: We make sure to re-sort.
    if j.kind == JObject:
        for k, v in j.fields: postProcessJson(v)
        j.fields.sort do (a, b: auto) -> int: cmpIgnoreCase(a[0], b[0])
    elif j.kind == JArray:
        for e in j.elems: postProcessJson(e)


#Proceduralized code found in lines ~73-76
#Altered to accept Path and then pass Path.string to writeFile
proc ExtractSqliteFromGFF*(GFFInput: GffRoot, SqliteLocation: Path) =
    if GFFInput.hasField("SQLite", GffStruct) and GFFInput["SQLite", GffStruct].hasField("Data", GffVoid):
        let blob = GFFInput["SQLite", GffStruct]["Data", GffVoid].string
        writeFile(SqliteLocation.string, decompress(blob, makeMagic("SQL3")))
        echo "Embedded SQLite database written to " & SqliteLocation.string


#Proceduralized code found in lines ~67-71
#Altered to accept Path and then pass Path.string to readFile
proc PackSqliteIntoGFF*(GFFTarget: GffRoot, SqliteLocation: Path) =
    let blob = compress(readFile(SqliteLocation.string), Algorithm.Zstd, makeMagic("SQL3"))
    GFFTarget["SQLite", GffStruct] = newGffStruct(10)
    GFFTarget["SQLite", GffStruct]["Data", GffVoid] = blob.GffVoid
    GFFTarget["SQLite", GffStruct]["Size", GffDword] = blob.len.GffDword