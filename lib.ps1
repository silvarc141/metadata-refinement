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
        [string]$ReplacementsPath = "$PSScriptRoot/replace.json",
        [string]$TemplatePath = "$PSScriptRoot/template.xml"
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
    $files | ForEach-Object { Log-Info "Matching file at path: $($_.FullName)" }
    $files
}

function Replace-IXMLMetaDataAll {
    param(
        [string]$Path,
        [string]$BWFMetaEditCommand = "bwfmetaedit",
        [string]$ReplacementsPath = "$PSScriptRoot/replace.json",
        [string]$TemplatePath = "$PSScriptRoot/template.xml",
        [switch]$NoConfirm
    )

    Log-Info "Using template file: $TemplatePath"
    Log-Info "Using replacements file: $ReplacementsPath"
    $replacements = Get-Content $ReplacementsPath | ConvertFrom-Json
    Log-Info "Replacements to be applied:"
    $replacements.PSObject.Properties | ForEach-Object {
        Log-Info "$($_.Name) -> $($_.Value)"
    }

    $files = Match-Files $Path

    if (-not $NoConfirm) {
        $confirmation = Read-Host "Are you sure you want to process $($files.Count) files? (Y/N)"
        if ($confirmation -ne 'Y') {
            Log-Info "Operation cancelled by user."
            return
        }
    }

    $files | ForEach-Object { Replace-IXMLMetaData `
        -FilePath $_.FullName `
        -BWFMetaEditCommand $BWFMetaEditCommand `
        -ReplacementsPath $ReplacementsPath `
        -TemplatePath $TemplatePath
    }

    Log-Info "Completed processing $($files.Count) files."
}
