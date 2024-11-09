import std/[json]

import /[css_generators, html_generators, html_tag_wrappers]
import ../../[interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

proc BuildTitle*(CharacterJSON: JsonNode): string

proc BuildTitle*(CharacterJSON: JsonNode): string =
    var 
        TitleBase = GetCharacterFullName(CharacterJSON) & ", "
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
    
    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        TitleBase = TitleBase & GetClassLabel(ClassesAndLevels[i][0], true) & " " & $ClassesAndLevels[i][1]
        if i != ClassesAndLevels.high:
            TitleBase = TitleBase & " / "
    
    return WrapTitle(TitleBase)