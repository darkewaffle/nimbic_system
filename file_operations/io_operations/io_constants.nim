const
    ExtensionJSON* = """.json"""
    ExtensionBIC* = """.bic"""
    ExtensionSQLite* = """.sqlite3"""
    ExtensionHTML* = """.html"""

    PatternExtensionJSON* = """\*""" & ExtensionJSON
    PatternExtensionBIC* = """\*""" & ExtensionBIC
    PatternExtensionSQlite* = """\*""" & ExtensionSQLite
    PatternExtensionHTML* = """\*""" & ExtensionHTML

    BackupDirectoryPrefix* = """BIC_Backup_"""
    PatternSubdirectoriesAll* = """\*"""
    PatternSubdirectoriesBackup* = """\""" & BackupDirectoryPrefix & """*"""