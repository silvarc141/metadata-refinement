# Basic replacing example.
# For more details read through lib.ps1.

# Load functions from lib.ps1 in script directory.
. $PSScriptRoot/lib.ps1

# Try-catch expression is for correctly handling exceptions.
try {
    # Perform metadata replacement on a path passed as an argument to this script.
    # Supports globbing, for example pass "*.wav" to match all wav files in current directory.
    # By default, replace.json is used for mapping template keywords to metadata paths from which to get new values.
    # By default, template.xml is used as a template iXML data, that should contain keywords which will be replaced with file-specific metadata values.
    Replace-IXMLMetaDataAll $args[0]
}
catch {
    Log-Error $_.Exception.Message
    exit 1
}
