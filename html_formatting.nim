import std/math

proc WrapTags(Input: string, Tag: string, Class: string = ""): string
proc WrapHTML*(Input: string): string
proc WrapHead*(Input: string): string
proc WrapStyle*(Input: string): string
proc WrapBody*(Input: string): string

proc WrapDiv*(Input: string, Class: string = ""): string
proc WrapTable*(Input: string, Class: string = "", WrapDiv: bool = false): string
proc WrapTH*(Input: string, Class: string = ""): string
proc WrapTR*(Input: string, Class: string = ""): string
proc WrapTD*(Input: string, Class: string = ""): string

proc CreateTableHeader*(InputValues: openArray[string], Class: string = "", ClassSuffix: bool = false): string
proc CreateTableRow*(InputValues: openArray[string], Class: string = ""): string
proc WidthStyle*(TableClass: string, THClass: string, NumberOfColumns: int): string
proc MakeTDTable*(TableData: openArray[string], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string


proc WrapTags(Input: string, Tag: string, Class: string = ""): string =
    if Class == "":
        return "<" & Tag & ">" & Input & "</" & Tag & ">"
    else:
        return "<" & Tag & " class=\"" & Class & "\">" & Input & "</" & Tag & ">"

proc WrapHTML*(Input: string): string =
    return WrapTags(Input, "html")

proc WrapHead*(Input: string): string =
    return WrapTags(Input, "head")

proc WrapBody*(Input: string): string =
    return WrapTags(Input, "body")

proc WrapStyle*(Input: string): string =
    return WrapTags(Input, "style")

proc WrapDiv*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "div", Class)

proc WrapSpan*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "span", Class)

proc WrapTable*(Input: string, Class: string = "", WrapDiv: bool = false): string =
    if WrapDiv:
        return WrapDiv(WrapTags(Input, "table", Class), Class)
    else:
        return WrapTags(Input, "table", Class)

proc WrapTH*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "th", Class)

proc WrapTR*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "tr", Class)

proc WrapTD*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "td", Class)

proc CreateTableHeader*(InputValues: openArray[string], Class: string = "", ClassSuffix: bool = false): string =
    var HeaderHTML: string
    for i in InputValues.low .. InputValues.high:
        var AttachClass = Class
        if ClassSuffix:
            AttachClass = Class & $(i+1)
        HeaderHTML = HeaderHTML & WrapTH(InputValues[i], AttachClass)
    return WrapTR(HeaderHTML, Class)

proc CreateTableRow*(InputValues: openArray[string], Class: string = ""): string =
    var RowHTML: string
    for i in InputValues.low .. InputValues.high:
        RowHTML = RowHTML & WrapTD(InputValues[i], Class)
    return WrapTR(RowHTML, Class)

proc WidthStyle*(TableClass: string, THClass: string, NumberOfColumns: int): string =
#    var TableWidth = NumberOfColumns * 10
#    if TableWidth < 50:
#        TableWidth = 50
    
    var ColumnWidth = floor(100 / NumberOfColumns).toInt
    
#    var TableStyle= " ." & TableClass & " {width: " & $TableWidth & "%;} "
    var THStyle = " ." & THClass & " {width: " & $ColumnWidth & "%;} "
    return THStyle
#    return TableStyle & THStyle

proc MakeTDTable*(TableData: openArray[string], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string =
    var
        TableHTML: string
        RowHTML: string

    for i in TableData.low .. TableData.high:
        RowHTML = RowHTML & WrapTD(TableData[i], CellClass)

#        if floorMod(i+1, TableWidth) != 0 and i == TableData.high:
#            RowHTML = RowHTML & WrapTD("", CellClass)

        if floorMod(i+1, TableWidth) == 0 or i == TableData.high:
            RowHTML = WrapTR(RowHTML)
            TableHTML = TableHTML & RowHTML
            RowHTML = ""

    return WrapTable(TableHTML, TableClass, WrapDiv)

proc MakeTDTable*(TableData: openArray[int], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string =
    var
        TableHTML: string
        RowHTML: string

    for i in TableData.low .. TableData.high:
        RowHTML = RowHTML & WrapTD($TableData[i], CellClass)

#        if floorMod(i+1, TableWidth) != 0 and i == TableData.high:
#            RowHTML = RowHTML & WrapTD("", CellClass)

        if floorMod(i+1, TableWidth) == 0 or i == TableData.high:
            RowHTML = WrapTR(RowHTML)
            TableHTML = TableHTML & RowHTML
            RowHTML = ""

    return WrapTable(TableHTML, TableClass, WrapDiv)

proc MakeStyle(InputPrefix: string, InputName: string, InputStyle: string): string =
    return InputPrefix & InputName & " " & InputStyle

proc MakeStyleClass*(InputName: string, InputStyle: string): string =
    return MakeStyle(".", InputName, InputStyle)

proc MakeStyleID*(InputName: string, InputStyle: string): string =
    return MakeStyle("#", InputName, InputStyle)