# shamelessly taken from https://github.com/mwrock/packer-templates

Write-Host "defragging..."
if ($null -ne (Get-Command Optimize-Volume -ErrorAction SilentlyContinue)) {
    Optimize-Volume -DriveLetter C
} else {
    Defrag.exe c: /H
}