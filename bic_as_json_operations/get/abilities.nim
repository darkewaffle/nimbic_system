import std/[json]

const
    AbilityContainer = [0, 0, 0, 0, 0, 0]
    GreatCharismaFeats =     [764, 765, 766, 767, 768, 769, 770, 771, 772, 773]
    GreatConstitutionFeats = [774, 775, 776, 777, 778, 779, 780, 781, 782, 783]
    GreatDexterityFeats =    [784, 785, 786, 787, 788, 789, 790, 791, 792, 793]
    GreatIntelligenceFeats = [794, 795, 796, 797, 798, 799, 800, 801, 802, 803]
    GreatWisdomFeats =       [804, 805, 806, 807, 808, 809, 810, 811, 812, 813]
    GreatStrengthFeats =     [814, 815, 816, 817, 818, 819, 820, 821, 822, 823]

proc GetCharacterStrength*(CharacterJSON: JsonNode): int
proc GetCharacterDexterity*(CharacterJSON: JsonNode): int
proc GetCharacterConstitution*(CharacterJSON: JsonNode): int
proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int
proc GetCharacterWisdom*(CharacterJSON: JsonNode): int
proc GetCharacterCharisma*(CharacterJSON: JsonNode): int

proc GetCharacterAbilityScoresStart*(CharacterJSON: JsonNode): array[6, int]
proc GetCharacterAbilityScoresCurrent*(CharacterJSON: JsonNode): array[6, int]
proc GetCharacterAbilityIncreaseFromLevels*(CharacterJSON: JsonNode): array[6, int]
proc GetCharacterAbilityIncreaseFromGreatFeats*(CharacterJSON: JsonNode): array[6, int]

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
