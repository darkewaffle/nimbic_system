proc WrapTags(Input: string, Tag: string, Class: string = ""): string
proc WrapHTML*(Input: string): string
proc WrapHead*(Input: string): string
proc WrapStyle*(Input: string): string
proc WrapBody*(Input: string): string

proc WrapDiv*(Input: string, Class: string = ""): string
proc WrapTable*(Input: string, Class: string = ""): string
proc WrapTH*(Input: string, Class: string = ""): string
proc WrapTR*(Input: string, Class: string = ""): string
proc WrapTD*(Input: string, Class: string = ""): string

proc CreateTableHeader*(InputValues: openArray[string]): string
proc CreateTableRow*(InputValues: openArray[string]): string

type
    LevelTableRow* = array[5, string]
    BasicsTableRow* = array[3, string]

const
    LevelTableColumns: LevelTableRow = ["Level", "Class", "Ability", "Feats", "Skills"]
    BasicsTableColumns1*: BasicsTableRow = ["Name", "Race", "Subrace"]
    BasicsTableColumns2*: BasicsTableRow = ["Deity", "Good / Evil", "Lawful / Chaotic"]
    HTMLStyle = """
    table, th, td {border: 1px solid #3A4550; border-collapse: collapse; color: #9BA1A6;}
    th, td {padding: 10px; text-align: center;}
    body {background-color: #000C18;}
    table {margin-left: auto; margin-right: auto; margin-top: 25px;}
    .basics {width: 50%;}
    .levels {width: 80%;}
    """

let
    LevelTableHeader* = CreateTableHeader(LevelTableColumns)
    StyleHeader* = WrapHead(WrapStyle(HTMLStyle))


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

proc WrapTable*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "table", Class)

proc WrapTH*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "th", Class)

proc WrapTR*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "tr", CLass)

proc WrapTD*(Input: string, Class: string = ""): string =
    return WrapTags(Input, "td", Class)





proc CreateTableHeader*(InputValues: openArray[string]): string =
    var HeaderHTML: string
    for i in InputValues.low .. InputValues.high:
        HeaderHTML = HeaderHTML & WrapTH(InputValues[i])
    return WrapTR(HeaderHTML)

proc CreateTableRow*(InputValues: openArray[string]): string =
    var HeaderHTML: string
    for i in InputValues.low .. InputValues.high:
        HeaderHTML = HeaderHTML & WrapTD(InputValues[i])
    return WrapTR(HeaderHTML)