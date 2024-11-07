import std/[algorithm, json, strutils]

from ../file_operations/interface_2da import GetSpellLabel

proc CharacterHasClassLevel*(CharacterJSON: JsonNode, RequiredClass: int, RequiredLevel: int): bool
proc CharacterHasClass*(CharacterJSON: JsonNode, RequiredClass: int): bool
proc CharacterHasRace*(CharacterJSON: JsonNode, RequiredRace: int): bool
proc CharacterHasSubrace*(CharacterJSON: JsonNode, RequiredSubrace: string): bool
proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool

proc GetCharacterLevel*(CharacterJSON: JsonNode): int
proc GetCharacterEpicLevels*(CharacterJSON: JsonNode): int

proc GetCharacterStrength*(CharacterJSON: JsonNode): int
proc GetCharacterDexterity*(CharacterJSON: JsonNode): int
proc GetCharacterConstitution*(CharacterJSON: JsonNode): int
proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int
proc GetCharacterWisdom*(CharacterJSON: JsonNode): int
proc GetCharacterCharisma*(CharacterJSON: JsonNode): int

const
    MaximumPreEpicLevel = 20
    AbilityContainer = [0, 0, 0, 0, 0, 0]
    GreatCharismaFeats =     [764, 765, 766, 767, 768, 769, 770, 771, 772, 773]
    GreatConstitutionFeats = [774, 775, 776, 777, 778, 779, 780, 781, 782, 783]
    GreatDexterityFeats =    [784, 785, 786, 787, 788, 789, 790, 791, 792, 793]
    GreatIntelligenceFeats = [794, 795, 796, 797, 798, 799, 800, 801, 802, 803]
    GreatWisdomFeats =       [804, 805, 806, 807, 808, 809, 810, 811, 812, 813]
    GreatStrengthFeats =     [814, 815, 816, 817, 818, 819, 820, 821, 822, 823]

proc CharacterHasClassLevel*(CharacterJSON: JsonNode, RequiredClass: int, RequiredLevel: int): bool =
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt == RequiredClass:
            if CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt >= RequiredLevel:
                return true
    return false


proc CharacterHasClass*(CharacterJSON: JsonNode, RequiredClass: int): bool =
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt == RequiredClass:
            return true
    return false

proc CharacterHasFeat*(CharacterJSON: JsonNode, RequiredFeat: int): bool =
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == RequiredFeat:
            return true
    return false

proc CharacterHasRace*(CharacterJSON: JsonNode, RequiredRace: int): bool =
    if CharacterJSON["Race"]["value"].getInt == RequiredRace:
        return true
    else:
        return false


proc CharacterHasSubrace*(CharacterJSON: JsonNode, RequiredSubrace: string): bool =
    if CharacterJSON["Subrace"]["value"].getStr == RequiredSubrace:
        return true
    else:
        return false


proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool =
    var CharacterLevel = 0
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        CharacterLevel = CharacterLevel + CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
    if CharacterLevel >= RequiredLevel:
        return true
    else:
        return false


proc GetCharacterLevel*(CharacterJSON: JsonNode): int =
    var CharacterLevel = 0
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        CharacterLevel = CharacterLevel + CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
    return CharacterLevel


proc GetCharacterEpicLevels*(CharacterJSON: JsonNode): int =
    var EpicLevels = GetCharacterLevel(CharacterJSON) - MaximumPreEpicLevel
    if EpicLevels < 0:
        return 0
    else:
        return EpicLevels


proc GetCharacterStrength*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Str"]["value"].getInt

proc GetCharacterDexterity*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Dex"]["value"].getInt

proc GetCharacterConstitution*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Con"]["value"].getInt

proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Int"]["value"].getInt

proc GetCharacterWisdom*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Wis"]["value"].getInt

proc GetCharacterCharisma*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Cha"]["value"].getInt

proc GetCharacterFirstName*(CharacterJSON: JsonNode): string =
    var FirstName = CharacterJSON["FirstName"]["value"]["0"].getStr
    removePrefix(FirstName, " ")
    removeSuffix(FirstName, " ")
    return FirstName

proc GetCharacterLastName*(CharacterJSON: JsonNode): string =
    var LastName = CharacterJSON["LastName"]["value"]["0"].getStr
    removePrefix(LastName, " ")
    removeSuffix(LastName, " ")
    return LastName


proc GetCharacterFullName*(CharacterJSON: JsonNode): string =
    var FullName = GetCharacterFirstName(CharacterJSON) & " " & GetCharacterLastName(CharacterJSON)
    removePrefix(FullName, " ")
    removeSuffix(FullName, " ")
    return FullName

proc GetCharacterDeity*(CharacterJSON: JsonNode): string =
    return CharacterJSON["Deity"]["value"].getStr

proc GetCharacterRace*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Race"]["value"].getInt

proc GetCharacterSubrace*(CharacterJSON: JsonNode): string =
    return CharacterJSON["Subrace"]["value"].getStr

proc GetCharacterGoodEvil*(CharacterJSON: JsonNode): int =
    return CharacterJSON["GoodEvil"]["value"].getInt

proc GetCharacterGoodEvilDescription*(CharacterJSON: JsonNode): string =
    var AlignValue = GetCharacterGoodEvil(CharacterJSON)
    if AlignValue > 75:
        return "Good"
    elif AlignValue < 25:
        return "Evil"
    else:
        return "Neutral"

proc GetCharacterLawfulChaotic*(CharacterJSON: JsonNode): int =
    return CharacterJSON["LawfulChaotic"]["value"].getInt

proc GetCharacterLawfulChaoticDescription*(CharacterJSON: JsonNode): string =
    var AlignValue = GetCharacterLawfulChaotic(CharacterJSON)
    if AlignValue > 75:
        return "Lawful"
    elif AlignValue < 25:
        return "Chaotic"
    else:
        return "Neutral"

proc GetCharacterClasses*(CharacterJSON: JsonNode): seq[array[2, int]] =
    var ClassesAndLevels: seq[array[2, int]]
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        var ClassID = CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt
        var ClassLevel = CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
        ClassesAndLevels.add [ClassID, ClassLevel]
    return ClassesAndLevels

proc GetCharacterAbilityIncreaseFromLevels*(CharacterJSON: JsonNode): array[6, int] =
    var AbilityIncreases = AbilityContainer
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        try:
            inc AbilityIncreases[CharacterJSON["LvlStatList"]["value"][i]["LvlStatAbility"]["value"].getInt]
        except KeyError:
            discard
    return AbilityIncreases

proc GetCharacterAbilityIncreaseFromGreatFeats*(CharacterJSON: JsonNode): array[6, int] =
    var AbilityIncreases = AbilityContainer
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        var FeatID = CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt
        if FeatID in GreatStrengthFeats:
            inc AbilityIncreases[0]

        elif FeatID in GreatDexterityFeats:
            inc AbilityIncreases[1]

        elif FeatID in GreatConstitutionFeats:
            inc AbilityIncreases[2]

        elif FeatID in GreatIntelligenceFeats:
            inc AbilityIncreases[3]

        elif FeatID in GreatWisdomFeats:
            inc AbilityIncreases[4]

        elif FeatID in GreatCharismaFeats:
            inc AbilityIncreases[5]
    return AbilityIncreases

proc GetCharacterAbilityScoresCurrent*(CharacterJSON: JsonNode): array[6, int] =
    var AbilityScores = AbilityContainer
    AbilityScores[0] = GetCharacterStrength(CharacterJSON)
    AbilityScores[1] = GetCharacterDexterity(CharacterJSON)
    AbilityScores[2] = GetCharacterConstitution(CharacterJSON)
    AbilityScores[3] = GetCharacterIntelligence(CharacterJSON)
    AbilityScores[4] = GetCharacterWisdom(CharacterJSON)
    AbilityScores[5] = GetCharacterCharisma(CharacterJSON)
    return AbilityScores

proc GetCharacterAbilityScoresStart*(CharacterJSON: JsonNode): array[6, int] =
    var
        StartingAbilities = AbilityContainer
        CurrentScores = GetCharacterAbilityScoresCurrent(CharacterJSON)
        IncreasesFromLevels = GetCharacterAbilityIncreaseFromLevels(CharacterJSON)
        IncreasesFromFeats = GetCharacterAbilityIncreaseFromGreatFeats(CharacterJSON)

    for i in StartingAbilities.low .. StartingAbilities.high:
        StartingAbilities[i] = CurrentScores[i] - IncreasesFromLevels[i] - IncreasesFromFeats[i]

    return StartingAbilities

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
    var SpellsByLevel: seq[seq[string]]
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt != ClassID:
            discard
        else:
            for j in 0 .. 9:
                var SpellsInLevel: seq[string]
                try:
                    for k in CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"].elems.low .. CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"].elems.high:
                        SpellsInLevel.add(GetSpellLabel(CharacterJSON["ClassList"]["value"][i]["KnownList" & $j]["value"][k]["Spell"]["value"].getInt,true))
                except KeyError:
                    break
                SpellsInLevel.sort()
                SpellsByLevel.add(SpellsInLevel)
    return SpellsByLevel