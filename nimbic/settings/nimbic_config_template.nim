const ConfigurationFileStarterText* = """
#NIMBIC Editor Configuration Settings

#Default directory to find BIC files for conversion.
#Ex: inputbic=C:\Users\Name\Neverwinter Nights\localvault
inputbic=

#Default directory to output .json files converted from BIC.
#Ex: outputjson=C:\Users\Name\Documents\NWN\BICto.json
outputjson=

#Default directory to find .json files for modification or conversion.
#Ex: inputjson=C:\Users\Name\Documents\NWN\BICto.json
inputjson=

#Default directory to output BIC files.
#Ex: outputbic=C:\Users\Name\Documents\NWN\.jsontoBIC
outputbic=

#Default directory to output HTML files.
#Ex: outputhtml=C:\Users\Name\Documents\NWN\.jsontoHTML
outputhtml=

#Determines if an HTML file should overwrite a file with the same name. If set to false
#then the original file will not be overwritten and the new file will have a random number
#added to the file name. This may be useful if characters in your vault share the same name
#and class levels (which will cause them to generate the same file name).
#Ex: overwritehtml=false
#Ex: overwritehtml=true
overwritehtml=true

#Directory where 2DA files can be read. These are necessary for certain operations.
#Currently only applies to --mode:maxhp and --mode:jsontohtml.
#Ex: 2dadir=C:\Users\Name\Documents\NWN2da
2dadir=

#Indicates whether or not nimbic should attempt to export/import Sqlite databases embedded in .bic files.
#This should only be necessary if you wish to view or modify the database using an external program. Regardless
#of this setting the database will be included in the .json as a string of compressed text.
#If true then, when found in the .bic, a .sqlite3 database file will be created alongside the .json file with the same root file name.
#For example characterabc.bic would produce characterabc.json and characterabc.sqlite3
#Additionally, if true, when converting back into .bic nimbic will look for a .sqlite3 file with the same root file name in the same 
#directory as the .json file and pack it into the .bic if it exists.
#Ex: sqlite=true
#Ex: sqlite=false
sqlite=false



## WARNING - DRAGONS ##
## WARNING - DRAGONS ##
## WARNING - DRAGONS ##

#Only modify the settings below once you have performed some test operations and have confirmed the altered .bic files are compatible with your server.
#When production=true AND nimbic is issued a command including the --prod or --production argument then the servervault path will be used for all operations.
#This means that subfolders of servervault will be scanned for .bic files, .json and .sqlite3 files will be written into each subfolder, modified within that subfolder and then converted back into .bic within the subfolder as well.
#There are also settings to automatically backup .bic files before they are overwritten as well as to automatically delete .json and .sqlite3 files after they are converted back into .bic.

#Ex: production=true
#Ex: production=false
production=false

#Autocleanup determines whether or not jsontobic operations will automatically delete the .json and .sqlite3 files used to create the .bic file.
#Ex: autocleanup=true
#Ex: autocleanup=false
autocleanup=false

#Autobackup determines whether or not jsontobic operations will create a backup copy of .bic files prior to being overwritten.
#If enabled then each time a .bic file will be overwritten it will first be copied to a new folder within the .bic directory with the name BIC_Backup_YYYYMMDD_HHMMSS
#Ex: autobackup=true
#Ex: autobackup=false
autobackup=false

#Directory of the server vault. When a production operation is performed (meaning production=true in this file and --prod or --production is included in the command)
#then all operations will take place within the server vault subfolders corresponding to each player.
#Ex: servervault=C:\Users\Name\Documents\Neverwinter Nights\servervault
servervault=
"""