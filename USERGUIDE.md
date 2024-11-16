
# User Guide

## What does Nimbic do?

Nimbic is designed to read Neverwinter Nights' .bic character files and then convert them into .json text files. Once they have been converted to .json then Nimbic (or any text editor, really) can modify them to adjust features of the character. Then when the adjustments are complete the .json file can be converted back into a playable .bic file that includes all of the changes in game.

If you just want to make changes to some personal character files then Nimbic can do a lot of that but it may be easier to use other tools. However because it is directory driven and can apply changes at scale it could be useful for servers that wish to make changes to certain 2DA properties and then retrofit them onto all characters rather than forcing players to re-level or introducing 'legacy' characters. I personally built it because I wanted to be able to, over time, continue to 'balance' characters against each other by granting automatic feats to classes or races, adjusting HP values, skill points and more.

Nimbic tries to make sure the changes will be compliant with ELC ('Enforce Legal Characters') when possible - however please keep in mind that may require changes to the server 2DA files as well. And some changes simply are not ELC compliant at all - for instance modifying a character's ability scores to have an additional +10 Strength will not, to my knowledge, ever be valid with ELC.

Last but not least Nimbic can also generate human readable .html character sheets from .json including all basic character info, a table of every level with feat selections and skill ranks and a full spellbook.

### Limitations

Certain things that you can change in 2DA just aren't really possible to apply to a character directly as they require input from the person that actually plays/builds the character. While Nimbic can, for example, grant a new automatic feat to a class it cannot address changing the levels at which a class earns epic bonus feats. Nimbic also does not support skill point changes at this time.

## 1. How does it work?

Nimbic is command-line only. Every command should take the form of

```
nimbic.exe --mode:modetype --argument:argumentvalue
```
with each mode type contextually accepting (and sometimes requiring) additional arguments. 

### 1a. Mode

This is the most important information to provide as Nimbic will not operate without it. The mode tells Nimbic what kind of files to look for and how they should be read or changed. It accepts the following values.

| File&nbsp;Conversion | Description | Requirements |
|-|-|-|
| `bictojson` | Nimbic will look for .bic files, convert them to .json and then write them to disk. This does not affect the .bic file. | `--input` <br/> `--output` <br/> *or* <br/> `nimbic.ini > inputbic` <br/> `nimbic.ini > outputjson` |
| `jsontobic` | Nimbic will look for .json files, convert them to .bic and then write them to disk. | `--input` <br/> `--output` <br/> *or* <br/> `nimbic.ini > inputjson` <br/> `nimbic.ini > outputbic` |
| `jsontohtml` | Nimbic will look for .json files, create a .html character sheet for each one and write the .html files to disk. | `--input` <br/> `--output` <br/> *or* <br/> `nimbic.ini > inputjson` <br/> `nimbic.ini > outputhtml` <br/><br/> *and* <br/><br/> `--2da` <br/> *or* <br/> `nimbic.ini > input2da`|
---
| Character Changes | Description | Requirements In Addition To <br/><br/> `--input` <br/> *or* <br/> `nimbic.ini > inputjson` |
|-|-|-|
| `addclassfeat` <br/> `removeclassfeat`| Nimbic will add the specified feat to each character that has the required class at the required level. The feat will be added to the character at that specific class level. | `--class` <br/> `--level` <br/> `--feat` |
| `addfeat` <br/> `removefeat` | Nimbic will add the specified feat to each character. | `--feat` |
| `alterclasshp` | Nimbic increase or decrease the hit points a class earns each level. Hit points per level have a minimum of 1 and no defined maximum. | `--class` <br/> `--hp` |
| `maxhp` | Nimbic will maximize the hit points a character has earned at each level up. | `--2da` <br/> *or* <br/> `nimbic.ini > input2da` |
| `modifyability` | Nimbic increase or decrease the base ability scores for a character. Base ability scores have a minimum of 3 and a maximum of 100. | At least one of <br/> `--str` <br/> `--dex` <br/> `--con` <br/> `--int` <br/> `--wis` <br/> `--cha`

### 1b. Arguments

Arguments are additional options you can provide Nimbic to specify exactly what a mode does. Some are optional, some are required on a per-mode basis. Optional arguments can usually be used to 'filter' which characters are affected. See **1c. Filtering** section below for details.

|File&nbsp;Conversion Arguments| Values&nbsp;Accepted | Usage |
|-|-|-|
| `--input` | "Directory location" | The directory location of the files to be input into the mode operation. Depending on the selected mode this directory will be scanned for .bic or .json files. |
| `--output` | "Directory location" | The directory location of the files to be output by the mode operation. Depending on the selected mode this directory will have .bic, .json or .html files written to it. |
| `--2da` | "Directory location" | The directory location where Nimbic can read .2da files. These are used to lookup values such as the HP a class earns per level or to find descriptors for numeric IDs (like translating spell ID 107 into 'Magic Missile' for a character sheet).

|Character&nbsp;Change Arguments| Values&nbsp;Accepted | Usage |
|-|-|-|
| `--level` | Integer 1 - 40 | Typically specifies the character level required for a character to be affected by a mode. However when used with a class mode it represents class level instead of character level. |
| `--class` | Integer 0 - 254 | The class ID or index as found in classes.2da. For example barbarian = 0, Wizard = 10, Blackguard = 31, etc. |
| `--race` | Integer 0 - 254 | The race ID or index as found in racial_types.2da. For example dwarf = 0, elf = 1, human = 6, etc. |
| `--subrace` | Text | Text value that would match the what a player input into the Subrace field during character creation. However when reading the subrace field all symbols are removed. So if a character has 'Sun-Touched' as a subrace then you would want to input `--subrace:suntouched` in order to match it. |
| `--feat` | Integer > 0 | The feat ID or index as found in feat.2da. For example Alertness = 0, Power Attack = 28, Great Constitution I = 774, etc. |
| `--str` <br/> `--dex` <br/> `--con` <br/> `--int` <br/> `--wis` <br/> `--cha` | Integer | Integer value representing how much an ability score should be increased or decreased. Regardless of the argument value the resulting score assigned to the character is limited to the range of 3 - 100. |
| `--hp` | Integer | Integer value representing how much a character's hit points gained per class level should be increased or decreased. Regardless of the argument value the hit points gained per level will always have a minimum of 1 with no defined maximum. |

### 1c. Filtering

Arguments that are not strictly required for a mode can still be used to provide 'filters' that determine which characters should be affected by the mode. Behind the scenes each character is evaluated by a 'Does this character meet all the requirements?' function which will first check if a character has or meets all of the requirements included in the command before any action is taken. 

---

*Note that these commands omit the directory arguments for brevity and convenience, find out how in the **2. Nimbic.ini Basic Settings** section below.*

---

Take for instance this command to increase HP per level for barbarian levels by 4.
```
nimbic.exe --mode:alterclasshp --class:0 --hp:4
```
This command will run successfully and will increase HP gained per barbarian level by 4 for all characters with barbarian levels.

But what if you only wanted it to affect a specific subset of those characters? Perhaps some kind of world event blessed only Plainsborne Half-orc barbarians?

```
nimbic.exe --mode:alterclasshp --class:0 --hp:4 --race:5 --subrace:plainsborne
```
In this case the mode does the exact same thing *except* that there are additional requirements used to evaluate each character before the HP change takes place, thus making it so that only characters that have barbarian levels, are half-orc and have the Plainsborne subrace will be affected.

---

The following arguments are not supported as filters.

```
--feat
--hp
--str
--dex
--con
--int
--wis
--cha
```

## 2. Nimbic.ini Basic Settings

The first (and, in fact, any) time you run Nimbic it will check for the existence of a *nimbic.ini* file in the same directory as *nimbic.exe*. If the file is not found then it will automatically create it. This file is used to pre-fill a number of settings that should make using Nimbic much more convenient and contains some 'advanced' settings as well.


| Basic Settings | Value Accepted | Description  |
|-|-|-|
| `inputbic` | Directory&nbsp;location | Equivalent to the `--input` argument for modes that require .bic files as input. |
| `outputjson` | Directory location | Equivalent to the `--output` argument for modes that produce .json files as output. |
| `inputjson` | Directory location | Equivalent to the `--input` argument for modes that require .json files as input. |
| `outputbic` | Directory location | Equivalent to the `--output` argument for modes that produce .bic files as output. |
| `outputhtml` | Directory location | Equivalent to the `--output` argument for modes that produce .html files as output. |
| `input2da` | Directory location | Equivalent to the `--2da` argument for modes that require 2da lookup information. |
| `sqlite` | `true` or `false` | If using `bictojson` mode this tells Nimbic if it should try to extract embedded .sqlite3 databases from .bic files. Even if set to false the database will remain embedded in the .json as compressed text and should not be affected. <br/> If using `jsontobic` mode this tells Nimbic if it should look for a .sqlite3 file alongside the .json file and overwrite the the database data embedded in the .json file with the contents of the .sqlite3 file. <br/> Unless you want to inspect or make modifications directly to character databases it is probably best to leave this set to `false`. |
| `autocleanup` | `true` or `false` | This determines if `jsontobic` mode will automatically delete the .json and .sqlite3 (if present) files used to create the .bic file. |
| `autobackup` | `true` or `false` | This determines whether or not `jsontobic` mode will automatically create a backup copy of .bic files prior to being overwritten. Backup files will be written to a subdirectory named `BIC_Backup_YYYYMMDD_HHMMSS` within the directory holding the .bic file. <br/> *Please keep in mind this could potentially significantly increase the amount of disk space your character vault consumes until the backups are purged. (See **4c. Advanced Modes** below.)*  |
| `overwritehtml` | `true` or `false` | Determines whether or not .html files should overwrite files with the same name. By default .html character sheet file names are generated as FirstName_LastName_ClassLevels.html but if you are producing files from a very large vault or know that some characters share the same names and class-level distribution then setting `overwritehtml=false` will keep the first/original file and then append a random number to the end of the filename for all files that would otherwise overwrite it. |

## 3. Directory Priority

You might have noticed that you can specify a directory as both a commandline argument and as a setting in the nimbic.ini file. If you run a command that includes the `--input` or `--output` argument while the input and output directories are already defined in nimbic.ini then the commandline argument 'wins' and takes precedence. This means that if you want to manually input from or output to a specific directory you can do so while nimbic.ini will continue to provide the other directory settings. The `--2da` argument and the `input2da` setting behave in the same way.

There is one other scenario however - if nimbic.ini has a `servervault` setting defined *and* the `production` setting is set to `true` *and* a command is run with the `--prod` argument then the `servervault` directory will take precedence and be used for all input and output operations. See  **4. Advanced Settings and Production Operations** section below for details.

## 4. Advanced Settings and Production Operations

**Warning, dragons ahead.**

These settings are intended to make it possible to make changes directly to entire server vaults by iterating through each player folder and creating or modifying files directly within it. Please be careful.

### 4a. Advanced Settings in nimbic.ini

| Advanced Settings | Value Accepted | Description | 
|-|-|-|
| `production` | `true` or `false` | This acts as a 'dual control' of sorts. Production operations can only be performed if this value is set to true and the `--prod` argument is also included in the command. |
| `servervault` | Directory&nbsp;Location | The server vault directory containing each player's individual character vault. When `--prod` is included in the command and `production=true` in nimbic.ini then the server vault and its subdirectories will act as both the input and output directories for the command (although `jsontohtml` will still write to the `outputhtml` directory.) |

### 4b. Advanced Modes

| Advanced Modes | Description | Requirements |
|-|-|-|
| `purgebackups` | This mode will delete all but one `BIC_Backup_*` directories found in the input directory for the command. The most recent backup will not be deleted. | `--input` <br/><br/> *or* <br/><br/> `nimbic.ini > inputbic` <br/><br/> *or* <br/><br/> `nimbic.ini > servervault` <br/> *and* <br/> `nimbic.ini > production=true`<br/> *and* <br/> `--prod` |
| `purgebackupsall` | This mode will delete all `BIC_Backup_*` directories found in the input directory for the command. | `--input` <br/><br/> *or* <br/><br/> `nimbic.ini > inputbic` <br/><br/> *or* <br/><br/> `nimbic.ini > servervault` <br/> *and* <br/> `nimbic.ini > production=true`<br/> *and* <br/> `--prod`
| `restorebackup` | This mode will attempt to copy .bic files found in the `--restorefrom` subdirectory back into the input directory. | `--restorefrom` <br/><br/> *and one of* <br/><br/> `--input` <br/><br/> *or* <br/><br/> `nimbic.ini > inputbic` <br/><br/> *or* <br/><br/> `nimbic.ini > servervault` <br/> *and* <br/> `nimbic.ini > production=true`<br/> *and* <br/> `--prod`

### 4c. Advanced Arguments

| Advanced Arguments| Values Accepted | Usage |
|-|-|-|
|`--prod`| No value | This acts as a 'dual control' of sorts. Production operations can only be performed if this value is included in the command and `production=true` in nimbic.ini. |
|`--restorefrom`| Directory name as <br/> `BIC_Backup_YYYYMMDD_HHMMSS` <br/> *or just* <br/> `YYYYMMDD_HHMMSS` | This specifies what backup directory name Nimbic should use to perform a backup restoration. |

## Command Examples / Cheatsheet

| Description | Command |
|-|-|
| Convert .bic to .json | `nimbic.exe --mode:bictojson` |
| Convert .json to .bic | `nimbic.exe --mode:jsontobic` |
| Convert .json to .html (requires 2da access)|`nimbic.exe --mode:jsontohtml` |
| Give Toughness feat to Monks at level 10|`nimbic.exe --mode:addclassfeat --class:5 --level:10 --feat:40` |
| Remove Deflect Arrows feat from Monks at level 2|`nimbic.exe --mode:removeclassfeat --class:5 --level:2 --feat:8` |
| Increase Wizard HP per level by 6|`nimbic.exe --mode:alterclasshp --class:10 --hp:6` |
| Maximize the HP earned per level for all characters and classes (requires 2da access)|`nimbic.exe --mode:maxhp` |
| Give Silent Spell to Gnomes at level 1|`nimbic.exe --mode:addfeat --feat:33 --race:2` |
| Give Half-orc Barbarians +2 Constitution and -2 Wisdom|`nimbic.exe --mode:modifyability --con:2 --wis:-2 --class:0 --race:5` |
| Purge all backups found in the `servervault` except for the latest one|`nimbic.exe --mode:purgebackups --prod` |
| Restore .bic backups in the `servervault` from directories dated 20241112_081500|`nimbic.exe --mode:restorebackup --restorefrom:20241112_081500 --prod` |

## Credits

Many thanks to the [neverwinter.nim project](https://github.com/niv/neverwinter.nim) whose code to convert GFF (.bic is a form of GFF) to .json and extract the Sqlite files within provided the basis this project.