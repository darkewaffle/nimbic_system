import std/[math]
import /[html_tag_wrappers]

proc CreateTableHeader*(InputValues: openArray[string], Class: string = "", ClassSuffix: bool = false): string
proc CreateTableRow*(InputValues: openArray[string], Class: string = ""): string
proc MakeTDTable*(TableData: openArray[string], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string
proc MakeTDTable*(TableData: openArray[int], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string


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

proc MakeTDTable*(TableData: openArray[string], TableClass: string, CellClass: string, TableWidth: int, WrapDiv: bool = false): string =
    var
        TableHTML: string
        RowHTML: string

    for i in TableData.low .. TableData.high:
        RowHTML = RowHTML & WrapTD(TableData[i], CellClass)
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
        if floorMod(i+1, TableWidth) == 0 or i == TableData.high:
            RowHTML = WrapTR(RowHTML)
            TableHTML = TableHTML & RowHTML
            RowHTML = ""

    return WrapTable(TableHTML, TableClass, WrapDiv)