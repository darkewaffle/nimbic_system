proc DisplayHelpGeneral() =
  echo "nim_bic_editor is a tool to programmatically modify Neverwinter Nights .bic character files which have been exported to JSON."
  echo "It is not really intended to be a tool to edit individual characters but rather to apply character edits to server vaults / batches all at one time to retroactively enforce changes made in 2DA files."
  echo ""
  echo "Call nim_bic_editor.exe with the following parameters:"
  echo ""

proc DisplayHelpMode() =
  echo "--mode or -m"
  echo "    Accepts the following values"
  echo "      addclassfeat = grant a new feat to a class at a specific level"
  echo "      removeclassfeat = remove a feat from a class at a specific level"
  echo ""

proc DisplayHelpClass() =
  echo "--class or -c"
  echo "    Accepts an integer value representing the class index as found in classes.2da"
  echo "    Typically this specifies which class will be affected by the selected mode operation"
  echo ""

proc DisplayHelpLevel() =
  echo "--level, --lvl, or -l"
  echo "    Accepts an integer value representing the level of the class to be modified"
  echo "    Typically this specifies at what level a feat will be added/removed"
  echo ""

proc DisplayHelpFeatID() =
  echo "--featid, --fid, or -f"
  echo "    Accepts an integer value representing the feat index as found in feat.2da"
  echo "    This identifies the feat that will be added/removed by a feat mode operation"
  echo ""

proc DisplayHelpDirectory() =
  echo "--dir or -d"
  echo "    Accepts a string representing the directory holding all of the JSON files to be modified."
  echo ""

proc DisplayHelpFile() =
  echo "--file"
  echo "    Accepts a string representing a single JSON file to be modified"
  echo ""

proc DisplayHelpParameters() =
  DisplayHelpMode()
  DisplayHelpClass()
  DisplayHelpLevel()
  DisplayHelpFeatID()
  DisplayHelpDirectory()
  DisplayHelpFile()

proc DisplayHelpExamples() =
  echo "Here are some simple examples."
  echo ""
  echo "If you wanted to grant Toughness to Wizards at Level 5..."
  echo "    nim_bic_editor.exe --mode:addclassfeat --class:10 --level:5 --featid:40"
  echo ""
  echo "If you wanted to remove Deflect Arrows from Monks at Level 2..."
  echo "    nim_bic_editor.exe --mode:removeclassfeat -c:5 -l:2 -f:8"
  echo ""
  
proc DisplayHelp*() =
  DisplayHelpGeneral()
  DisplayHelpParameters()
  DisplayHelpExamples()