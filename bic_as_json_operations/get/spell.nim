import std/[algorithm, json]

from ../../file_operations/interface_2da import GetSpellLabel

proc GetCharacterSpellsFromClassAsSpellIDs*(CharacterJSON: JsonNode, ClassID: int): seq[seq[int]]
proc GetCharacterSpellsFromClassAsNames*(CharacterJSON: JsonNode, ClassID: int): seq[seq[string]]

proc GetCharacterSpellsFromClassAsSpellIDs*(CharacterJSON: JsonNode, ClassID: int): seq[seq[int]] =
    var SpellsByLevel: seq[seq[int]]
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt != ClassID:
            discard
        else:
            for j in 0 .. 9:
                var SpellsInLevel: seq[int]
                try:
                    for k in CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"].elems.low .. CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"].elems.high:
                        SpellsInLevel.add(CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"][k]["Spell"]["value"].getInt)
                except KeyError:
                    break
                SpellsByLevel.add(SpellsInLevel)
    return SpellsByLevel

proc GetCharacterSpellsFromClassAsNames*(CharacterJSON: JsonNode, ClassID: int): seq[seq[string]] =
    #Warning: This will return empty values if interface_2da > Initialize2DAs has not been run.
    #Currently this proc is only used in file_operations\conversion\html\table_spellbook.nim to create
    #the HTML spellbook populated with spell names.

    var
        SpellsByLevelAsID = GetCharacterSpellsFromClassAsSpellIDs(CharacterJSON, ClassID)
        SpellsByLevelAsName: seq[seq[string]]
    
    for i in SpellsByLevelAsID.low .. SpellsByLevelAsID.high:
        var SpellNamesForOneLevel: seq[string]
        for j in SpellsByLevelAsID[i].low .. SpellsByLevelAsID[i].high:
            SpellNamesForOneLevel.add(GetSpellLabel(SpellsByLevelAsID[i][j]))
        SpellNamesForOneLevel.sort()
        SpellsByLevelAsName.add(SpellNamesForOneLevel)
    return SpellsByLevelAsName