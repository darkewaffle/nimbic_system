proc WrapTags(Input: string, Tag: string, Class: string = ""): string
proc WrapHTML*(Input: string): string
proc WrapHead*(Input: string): string
proc WrapTitle*(Input: string): string 
proc WrapStyle*(Input: string): string
proc WrapBody*(Input: string): string
proc WrapDiv*(Input: string, Class: string = ""): string
proc WrapSpan*(Input: string, Class: string = ""): string
proc WrapTable*(Input: string, Class: string = "", WrapDiv: bool = false): string
proc WrapTH*(Input: string, Class: string = ""): string
proc WrapTR*(Input: string, Class: string = ""): string
proc WrapTD*(Input: string, Class: string = ""): string

proc WrapTags(Input: string, Tag: string, Class: string = ""): string =
    if Class == "":
        return "<" & Tag & ">" & Input & "</" & Tag & ">"
    else:
        return "<" & Tag & " class=\"" & Class & "\">" & Input & "</" & Tag & "> <!-- " & Class & " -->"

proc WrapHTML*(Input: string): string =
    return WrapTags(Input, "html")

proc WrapHead*(Input: string): string =
    return WrapTags(Input, "head")

proc WrapTitle*(Input: string): string =
    return WrapTags(Input, "title")

proc WrapStyle*(Input: string): string =
    return WrapTags(Input, "style")

proc WrapBody*(Input: string): string =
    return WrapTags(Input, "body")

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