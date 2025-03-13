# Metadata Refinement

Simple metadata mass copy-and-replace tool for copying parts of audio file metadata into other parts (mainly iXML).

## How to install

On most platforms:
[BWF MetaEdit CLI](https://github.com/MediaArea/BWFMetaEdit) has to be installed and in PATH. Functions may also take a BWFMetaEditCommand argument.
If not on Windows, Powershell is needed.
If using Nix, only nix-shell in the nix folder is needed, Powershell and packaged [BWF MetaEdit CLI](https://github.com/MediaArea/BWFMetaEdit) are included.

## How to use

For now it's just Powershell functions. 'src/lib.ps1' can be dotsourced.
Otherwise, there are 'src/simple-*.ps1' scripts for basic usage.
By default, template.xml and replace.json in script folder are used.
'replace.json' contains key/value pairs, where key is a string to match in the template and value is a Powershell object path pointing to audio file metadata elements.
'template.xml' contains iXML template which should contain key from 'replace.json' in places where value from metadata should replace them.

## How does it work

A thin wrapper around [BWF MetaEdit CLI](https://github.com/MediaArea/BWFMetaEdit), written in Powershell for cross-platforming and ubiquity (on Windows).

## Why does this exist

Made for [BIRDTUNE](https://birdtune.com/)
