# Clean updates
Write-Host "Cleaning updates.."
Stop-Service -Name wuauserv -Force
Remove-Item c:\Windows\SoftwareDistribution\Download\* -Recurse -Force
Start-Service -Name wuauserv