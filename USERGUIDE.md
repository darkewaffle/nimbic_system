## Full Documentation

Nimbic is command-line only. Every command should take the form of

`nimbic.exe --mode:modetype`

with each mode type contextually supporting (or sometimes requiring) additional arguments.

#### Command Line Arguments

1. Mode - This is the most important argument to provide as Nimbic will not operate without it. The mode tells Nimbic what kind of files to look for and how they should be read or changed. It supports the following values.
        1. File Conversions
```
            --mode:bictojson
```
```
        --mode:jsontobic
```
    --mode:jsontohtml
```