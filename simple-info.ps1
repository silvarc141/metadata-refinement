# Load functions from lib.ps1 in script directory.
. $PSScriptRoot/lib.ps1

# Try-catch expression is for correctly handling exceptions.
try {
    # Get files at path and list metadata properties and their paths that can be used in replace.json file.
    # Supports globbing, for example pass "*.wav" to match all wav files in current directory.
    Get-MetaDataInfo $args[0]
}
catch {
    Log-Error $_.Exception.Message
    exit 1
}
