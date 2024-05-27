param (
    [string]$name
)

if ([string]::IsNullOrWhiteSpace($name)) {
    Write-Host "Error: The name parameter is empty." -ForegroundColor Red
    exit 1
}

pandoc -t revealjs -s -o "$name.html" "$name.md"