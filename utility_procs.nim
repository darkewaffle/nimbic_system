import std/math

proc IfNoLevelThen1*(InputLevel: int): int
proc CalculateAbilityModifier*(InputAbility: int): int

proc IfNoLevelThen1*(InputLevel: int): int =
  if InputLevel > 0 and InputLevel <= 40:
    return InputLevel
  else:
    return 1

proc CalculateAbilityModifier*(InputAbility: int): int =
  var AbilityMod = floor((InputAbility - 10)/2).int
  if AbilityMod < -3:
    AbilityMod = -3
  elif AbilityMod > 100:
    AbilityMod = 100
  return AbilityMod