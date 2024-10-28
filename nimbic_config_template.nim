const ConfigurationFileStarterText* = """
#NIMBIC Editor Configuration Settings

#Default directory to find BIC files for conversion.
#Ex: inputbic=C:\Users\Name\Neverwinter Nights\localvault
inputbic=

#Default directory to output JSON files converted from BIC.
#Ex: outputjson=C:\Users\Name\Documents\BICtoJSON
outputjson=

#Default directory to find JSON files for modification or conversion.
#Ex: inputjson=C:\Users\Name\Documents\BICtoJSON\Modify
inputjson=

#Default directory to output BIC files.
#Ex: outputbic=C:\Users\Name\Documents\JSONtoBIC
outputbic=

#Directory where 2DA files can be read. These are necessary for certain operations.
#Currently only applies to --mode:maxhp.
#Ex: 2dadir=C:\Users\Name\Documents\NWN2da
2dadir=

#Only modify the settings below once you have performed some test operations and have confirmed the altered .bic files are compatible with your module/server.
#When production=true the servervault path will be used for all operations. Subfolders of \servervault will be scanned for .bic files
#with .json files being written within each player's folder. The .bic files will be backed up to a timestamped folder within the player folder prior to being overwritten.
#Ex: production=false
#Ex: production=true
production=false
#Ex: servervault=C:\Users\Name\Documents\Neverwinter Nights\servervault
servervault=
"""