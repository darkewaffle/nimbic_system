## Quick Start Guide

1. Download the appropriate copy of Nimbic from releases.

2. Run the nimbic.exe program from commandline (no arguments necessary) or by double-clicking on it to automatically generate the nimbic.ini configuration file.

3. Open the nimbic.ini file in a text editor, fill out the following lines and save the file.
    - inputbic = The directory location of the .bic files that Nimbic will convert to .json.
    - outputjson = The directory location where Nimbic will write .json files after converting them from .bic.
    - inputjson = The directory location of the .json files that Nimbic will modify.
        - It is probably most convenient to use the same directory for both outputjson and inputjson.
    - outputbic = The directory location of the .bic files Nimbic will create when converting back into .bic from .json.
        - *This should not be the same as inputbic until you have tested the .bic output files to ensure they are compliant with your server, otherwise you risk them being overwritten.*
    - outputhtml = The directory location where Nimbic will write .html character sheets.

4. Open a command prompt and navigate to the directory holding Nimbic.

5. Start making changes! All Nimbic commands should begin with nimbic.exe and all arguments passed to it should take the form of --argument:value. Here is an example 'workflow' that you might want to try.
    - First tell nimbic to convert your .bic files into .json files.
        `nimbic.exe --mode:bictojson`
    - Then tell nimbic to give Wizards the Toughness feat at level 5.
        `nimbic.exe --mode:addclassfeat --class:10 --level:5 --feat:40`
    - Then raise Wizards HP per level by 4.
        `nimbic.exe --mode:alterclasshp --class:10 --hp:4`
    - Give Luck of Heroes to all characters that have reached level 21
        `nimbic.exe --mode:addfeat --level:21 --feat:382`
    - Create some character sheets out of your newly modified characters.
        `nimbic.exe --mode:jsontohtml`
    - Finally convert your updated characters back to .bic to actually play them.
        `nimbic.exe --mode:jsontobic`

6. That's all there is to it. Remember that if your inputbic and outputbic directories are different (and they should be - at least initially) then you may have to copy files from your outputbic folder to your character vault folder to actually use them.