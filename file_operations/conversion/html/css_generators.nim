import std/[math]

proc MakeStyle(InputPrefix: string, InputName: string, InputStyle: string): string
proc MakeStyleClass*(InputName: string, InputStyle: string): string
proc MakeStyleID*(InputName: string, InputStyle: string): string
proc WidthStyle*(TableClass: string, THClass: string, NumberOfColumns: int): string
proc MakeStyleWidth*(ElementClass: string, NumberOfElements: int, MaximumElementsPerRow: int): string
proc MakeStyleFlex*(ElementClass: string, NumberOfElements: int, MaximumElementsPerRow: int, FlexGrow: int, FlexShrink: int): string
proc CalculateWidth*(NumberOfElements: int, MaximumElementsPerRow: int): int


proc MakeStyle(InputPrefix: string, InputName: string, InputStyle: string): string =
    return InputPrefix & InputName & " " & InputStyle

proc MakeStyleClass*(InputName: string, InputStyle: string): string =
    return MakeStyle(".", InputName, InputStyle)

proc MakeStyleID*(InputName: string, InputStyle: string): string =
    return MakeStyle("#", InputName, InputStyle)


proc WidthStyle*(TableClass: string, THClass: string, NumberOfColumns: int): string =
    var ColumnWidth = floor(100 / NumberOfColumns).toInt
    var THStyle = " ." & THClass & " {width: " & $ColumnWidth & "%;} "
    return THStyle


proc MakeStyleWidth*(ElementClass: string, NumberOfElements: int, MaximumElementsPerRow: int): string =
    var WidthStyle = "{width:" & $CalculateWidth(NumberOfElements, MaximumElementsPerRow) & "%;}"
    return MakeStyleClass(ElementClass, WidthStyle)

proc MakeStyleFlex*(ElementClass: string, NumberOfElements: int, MaximumElementsPerRow: int, FlexGrow: int, FlexShrink: int): string =
    var FlexStyle = "{flex:" & $FlexGrow & " " & $FlexShrink & " " & $CalculateWidth(NumberOfElements, MaximumElementsPerRow) & "%;}"
    return MakeStyleClass(ElementClass, FlexStyle)

proc CalculateWidth*(NumberOfElements: int, MaximumElementsPerRow: int): int =
    var 
        AvailableWidth = (100 * (1 + floor((NumberOfElements - 1) / MaximumElementsPerRow))).toInt
        WidthPerElement = (floor(AvailableWidth / NumberOfElements)).toInt - 3
    return WidthPerElement