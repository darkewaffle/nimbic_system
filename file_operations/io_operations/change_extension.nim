import std/[paths]

import /[io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]



proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string
proc SetFileExtensionJSON*(FileLocation: string): string
proc SetFileExtensionBIC*(FileLocation: string): string
proc SetFileExtensionSqlite*(FileLocation: string): string



proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string =
    var SplitPath = splitFile(Path FileLocation)
    var NewPath = SplitPath.dir / SplitPath.name
    NewPath = addFileExt(NewPath, NewExtension)
    return $NewPath

proc SetFileExtensionJSON*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionJSON)

proc SetFileExtensionBIC*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionBIC)

proc SetFileExtensionSqlite*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionSqlite)