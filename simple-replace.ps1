# Basic usable example
# For more details read through lib.ps1

# Load functions from lib.ps1 in script directory
. $PSScriptRoot/lib.ps1

# Try-catch expression is for correctly handling exceptions
try {
    # Perform the replacing on a path passed as an argument to this script
    Replace-IXMLMetaDataAll $args[0]
}
catch {
    Log-Error $_.Exception.Message
    exit 1
}
