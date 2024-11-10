import std/[paths]

import /[io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]



proc ReplaceFileExtension*(FileLocation: Path, NewExtension: string): Path
proc SetFileExtensionJSON*(FileLocation: Path): Path
proc SetFileExtensionBIC*(FileLocation: Path): Path
proc SetFileExtensionSqlite*(FileLocation: Path): Path



proc ReplaceFileExtension*(FileLocation: Path, NewExtension: string): Path =
    var 
        SplitPath = splitFile(FileLocation)
        NewPath = SplitPath.dir / SplitPath.name
    NewPath = addFileExt(NewPath, NewExtension)
    return NewPath

proc SetFileExtensionJSON*(FileLocation: Path): Path =
    return ReplaceFileExtension(FileLocation, ExtensionJSON)

proc SetFileExtensionBIC*(FileLocation: Path): Path =
    return ReplaceFileExtension(FileLocation, ExtensionBIC)

proc SetFileExtensionSqlite*(FileLocation: Path): Path =
    return ReplaceFileExtension(FileLocation, ExtensionSqlite)