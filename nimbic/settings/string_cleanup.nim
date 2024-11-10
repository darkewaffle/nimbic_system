import std/[strutils]

proc CleanDirectoryName*(DirtyValue: string): string

proc CleanDirectoryName*(DirtyValue: string): string =
    var CleanValue = replace(DirtyValue, "\"", "")
    CleanValue = replace(CleanValue, "'", "")
    #char(47) = /
    removeSuffix(CleanValue, char(47))
    #char(92) = \
    removeSuffix(CleanValue, char(92))
    return CleanValue