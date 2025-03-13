function Log-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Log-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Replace-IXMLMetaData {
    param(
        [string]$FilePath,
        [string]$BWFMetaEditCommand = "bwfmetaedit",
        [string]$ReplacementsPath = "./replace.json",
        [string]$TemplatePath = "./template.xml"
    )
    Log-Info "Starting metadata edit process for $FilePath"

    $replacements = Get-Content $ReplacementsPath | ConvertFrom-Json
    $template = Get-Content $TemplatePath -Raw
    $IXMLContent = $template

    $tempFilePath = "./temp.xml"
    $cmdArgs = $FilePath, "--out-xml=$tempFilePath"
    & $BWFMetaEditCommand $cmdArgs
    if ($LASTEXITCODE -ne 0) { throw "BWFMetaEdit failed to extract metadata" }

    $metaDataDoc = New-Object xml
    $metaDataDoc.Load((Convert-Path $tempFilePath))

    Log-Info "Processing replacements"
    foreach ($property in $replacements.PSObject.Properties) {
        $key = $property.Name
        $propertyPath = $property.Value

        $value = Invoke-Expression "`$metaDataDoc.conformance_point_document.File.$propertyPath"
        if ($null -eq $value) {
            throw "Property not found: $propertyPath"
        }
        
        $IXMLContent = $IXMLContent -replace [regex]::Escape($key), $value
        Log-Info "For $FilePath replacing key `"$key`" in iXML with value from `"$propertyPath`" (value: $value)"
    }

    $inIXMLPath = "$FilePath.iXML.xml"
    $IXMLContent | Out-File -FilePath $inIXMLPath -Encoding UTF8

    Log-Info "Applying iXML content to audio file"
    $cmdArgs = $FilePath, "--in-ixml-xml"
    & $BWFMetaEditCommand $cmdArgs
    if ($LASTEXITCODE -ne 0) { throw "BWFMetaEdit failed to apply iXML content" }

    Remove-Item $tempFilePath
    Remove-Item $inIXMLPath

    Log-Info "Metadata edit process completed successfully"
}

function Match-Files {
    param([string]$Path)
    $files = Get-ChildItem $Path -Recurse
    $files | Foreach-Object { Log-Info "Matching file at path: $($_.FullName)" }
    Log-Info "Matched $($files.length) files"
    $files
}

function Replace-IXMLMetaDataAll {
    param(
        [string]$Path,
        [string]$BWFMetaEditCommand = "bwfmetaedit",
        [string]$ReplacementsPath = "./replace.json",
        [string]$TemplatePath = "./template.xml"
    )

    $files = Get-ChildItem $Path -Recurse
    $files | Foreach-Object {$_}
}

# try {
#     Replace-IXMLMetaDataAll
# }
# catch {
#     Log-Error $_.Exception.Message
#     exit 1
# }
