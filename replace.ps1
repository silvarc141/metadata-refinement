

$bwfmetaeditCommand = "bwfmetaedit"
$keysJson = "replace.json"
$template = "template.xml"

$replacements = Get-Content $JsonFile | ConvertFrom-Json

$content = Get-Content $TemplateFile -Raw

foreach ($property in $replacements.PSObject.Properties) {
    $key = $property.Name
    $value = $property.Value
    $content = $content -replace [regex]::Escape($key), $value
}

$content | Set-Content $OutputFile
