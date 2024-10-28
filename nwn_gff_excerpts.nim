import std/[strutils, algorithm, streams, json, tables]
import neverwinterdotnim/neverwinter/[compressedbuf, gff, gffjson]

#These are procedures or code-converted-to-procedures taken directly from nwn_gff.nim
proc postProcessJson*(j: JsonNode)
proc ExtractSqliteFromGFF*(GFFInput: GffRoot, SqlitePath: string)
proc PackSqliteIntoGFF*(GFFTarget: GffRoot, SqlitePath: string)


#Procedure copied as is and set for export with *.
proc postProcessJson*(j: JsonNode) =
  ## Post-process json before emitting: We make sure to re-sort.
  if j.kind == JObject:
    for k, v in j.fields: postProcessJson(v)
    j.fields.sort do (a, b: auto) -> int: cmpIgnoreCase(a[0], b[0])
  elif j.kind == JArray:
    for e in j.elems: postProcessJson(e)


#Proceduralized code found in lines ~73-76
proc ExtractSqliteFromGFF*(GFFInput: GffRoot, SqlitePath: string) =
  if GFFInput.hasField("SQLite", GffStruct) and GFFInput["SQLite", GffStruct].hasField("Data", GffVoid):
    let blob = GFFInput["SQLite", GffStruct]["Data", GffVoid].string
    writeFile(SqlitePath, decompress(blob, makeMagic("SQL3")))


#Proceduralized code found in lines ~67-71
proc PackSqliteIntoGFF*(GFFTarget: GffRoot, SqlitePath: string) =
  let blob = compress(readFile(SqlitePath), Algorithm.Zstd, makeMagic("SQL3"))
  GFFTarget["SQLite", GffStruct] = newGffStruct(10)
  GFFTarget["SQLite", GffStruct]["Data", GffVoid] = blob.GffVoid
  GFFTarget["SQLite", GffStruct]["Size", GffDword] = blob.len.GffDword