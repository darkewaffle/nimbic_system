import std/[json]

#[
Metamagic Feats
11 = empower
12 = extend
25 = maximize
29 = quicken
33 = silent
37 = still

QBMeta
1 = empower
2 = extend
4 = maximize
8 = quicken
16 = silence
32 = still
]#

const
    QBType_Feat = 4
    QBType_Skill = 3
    QBType_Spell = 2
    QBType_SpellLike = 44
    MetamagicFeats = [11, 12, 25, 29, 33, 37]
    MetamagicQBMeta = [1, 2, 4, 8, 16, 32]

let
    QBObject_Empty = %*{"__struct_id": 0, "QBObjectType": {"type": "byte", "value": 0}}

proc RemoveFeatFromQB*(CharacterJSON: JsonNode, FeatID: int)
proc RemoveQB(CharacterJSON: JsonNode, QBType: int, QBIdentifier: int)
proc RemoveMetamagicSpellFromQB(CharacterJSON: JsonNode, QBType: int, QBMeta: int)

proc RemoveFeatFromQB*(CharacterJSON: JsonNode, FeatID: int) =
    RemoveQB(CharacterJSON, QBType_Feat, FeatID)
    for i in MetamagicFeats.low .. MetamagicFeats.high:
        if FeatID == MetamagicFeats[i]:
            RemoveMetamagicSpellFromQB(CharacterJSON, QBType_Spell, MetamagicQBMeta[i])

proc RemoveQB(CharacterJSON: JsonNode, QBType: int, QBIdentifier: int) =
    for i in CharacterJSON["QBList"]["value"].elems.low .. CharacterJSON["QBList"]["value"].elems.high:
        if CharacterJSON["QBList"]["value"][i]["QBObjectType"]["value"].getInt == QBType:
            if CharacterJSON["QBList"]["value"][i]["QBINTParam1"]["value"].getInt == QBIdentifier:
                CharacterJSON["QBList"]["value"].elems.delete(i)
                CharacterJSON["QBList"]["value"].elems.insert(QBObject_Empty, i)

proc RemoveMetamagicSpellFromQB(CharacterJSON: JsonNode, QBType: int, QBMeta: int) =
    for i in CharacterJSON["QBList"]["value"].elems.low .. CharacterJSON["QBList"]["value"].elems.high:
        if CharacterJSON["QBList"]["value"][i]["QBObjectType"]["value"].getInt == QBType:
            if CharacterJSON["QBList"]["value"][i]["QBMetaType"]["value"].getInt == QBMeta:
                CharacterJSON["QBList"]["value"].elems.delete(i)
                CharacterJSON["QBList"]["value"].elems.insert(QBObject_Empty, i)