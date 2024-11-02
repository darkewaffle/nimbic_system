import std/[strutils, algorithm, streams, json, tables, os, paths, dirs]
import std/private/osfiles
import object_settingspackage
import read2da
import io_operations

proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage)

proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "JSON to HTML start: " & $InputFile