### Quick Start Guide
1. Download the appropriate copy of Nimbic from releases.  
2. Run the nimbic.exe program from commandline (no arguments necessary) or by double-clicking on it to generate the nimbic.ini configuration file.  
3. Open the nimbic.ini file in a text editor, fill out the following lines and save the file.  
    1. inputbic = The directory location of the .bic files that Nimbic will convert to .json.  
    2. outputjson = The directory location where Nimbic will write .json files after converting them from .bic.  
    3. inputjson = The directory location of the .json files that Nimbic will modify.  
        1. Note: It is probably most convenient to use the same directory for both outputjson and inputjson.  
    4. outputbic = The directory location of the .bic files Nimbic will create when converting back into .bic from .json.  
        1. Note: This should not be the same as inputbic until you have tested the .bic output files to ensure they are compliant with your server.  
    5. outputhtml = The directory location where Nimbic will write .html character sheets.  
4. Open a command prompt and navigate to the directory holding Nimbic.  
5. Start making changes! All Nimbic commands should begin with nimbic.exe and all arguments passed to it should take the form of --argument:value. Here is an example 'workflow' that you might want to try.  
    1. First tell nimbic to convert your .bic files into .json files.  
        1. nimbic.exe --mode:bictojson  
    2. Then tell nimbic to give Wizards the Toughness feat at level 5.  
        1. nimbic.exe --mode:addclassfeat --class:10 --level:5 --feat:40  
    3. Then raise Wizards HP per level by 4.  
        1. nimbic.exe --mode:alterclasshp --class:10 --hp:4  
    4. Give Luck of Heroes to all characters that have reached level 21.  
        1. nimbic.exe --mode:addfeat --level:21 --feat:382  
    5. Create some character sheets out of your newly modified characters.  
        1. nimbic.exe --mode:jsontohtml  
    6. Finally convert your updated characters back to .bic to actually play them.  
        1. nimbic.exe --mode:jsontobic  
6. That's all there is to it. Remember that if your inputbic and outputbic directories are different (and they should be - at least initially) that you may have to copy files from your outputbic folder to your character vault folder to actually use them.  