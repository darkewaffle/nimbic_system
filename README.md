# nimbic_system

## A command-line utility for modifying Neverwinter Nights' .bic character files. Since it is directory driven it is intended to modify entire character vaults or server vaults in a single operation - such as retrofitting server-level 2DA changes onto the server's characters without requiring them to be relevelled or invalidated.

### [Click Here For Quick Start Guide](https://github.com/darkewaffle/nimbic_system/blob/main/QUICKSTART.md)

### Full Documentation

Nimbic is command-line only. Every command should take the form of

`nimbic.exe --mode:modetype`

with each mode type contextually supporting (or sometimes requiring) additional arguments.

## Command Line Arguments

1. Mode `--mode:modetype`
    - This is the most important argument to provide as Nimbic will not operate without it. The mode tells Nimbic what kind of files to look for and how they should be read or changed. It supports the following values.
        1. File Conversions
        `--mode:bictojson
        --mode:jsontobic
        --mode:jsontohtml`