import std/[os, sequtils]

const
  ExtensionJSON* = """.json"""
  ExtensionBIC* = """.bic"""
  FilterExtensionJSON = """\*""" & ExtensionJSON
  FilterExtensionBIC = """\*""" & ExtensionBIC

var parentdir = """C:\Program Files (x86)\Steam\steamapps\common\Neverwinter Nights\data\lcv"""
var subdirpattern = """\*"""
var dirseq = toSeq(walkDirs(parentdir & subdirpattern))
var filepattern: string

var fileseq: seq[string]

#var PatternMatches = toSeq(walkPattern(SearchPattern))
#var SearchPattern = DirectoryPath & FileTypePattern

for i in dirseq.low .. dirseq.high:
  filepattern = dirseq[i] & FilterExtensionBIC
  fileseq = concat(fileseq, toSeq(walkPattern(filepattern)))

for i in fileseq.low .. fileseq.high:
  echo fileseq[i]