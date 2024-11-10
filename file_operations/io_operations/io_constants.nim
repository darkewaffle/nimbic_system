import std/[paths]

const
    ExtensionJSON* = "json"
    ExtensionBIC* = "bic"
    ExtensionSQLite* = "sqlite3"
    ExtensionHTML* = "html"

    PatternExtensionJSON* = Path("""\*.""" & ExtensionJSON)
    PatternExtensionBIC* = Path("""\*.""" & ExtensionBIC)
    PatternExtensionSQlite* = Path("""\*.""" & ExtensionSQLite)
    PatternExtensionHTML* = Path("""\*.""" & ExtensionHTML)

    BackupDirectoryPrefix* = "BIC_Backup_"
    PatternSubdirectoriesAll* = Path("""\*""")
    PatternSubdirectoriesBackup* = Path("""\""" & BackupDirectoryPrefix & "*")