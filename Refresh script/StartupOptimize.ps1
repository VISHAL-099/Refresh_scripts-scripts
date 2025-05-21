# Clear Temp Files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Stop heavy background apps
$appsToKill = @("Teams", "OneDrive", "YourPhone", "Skype")
foreach ($app in $appsToKill) {
    Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Restart Windows Explorer (refresh)
Stop-Process -Name explorer -Force
Start-Process explorer.exe

# Display RAM Usage
$ram = Get-CimInstance Win32_OperatingSystem
$usedMemory = [math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / 1MB, 2)
$totalMemory = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)
Write-Host "🧠 RAM Usage: $usedMemory GB / $totalMemory GB"

# Optional: Add a beep or notification
[console]::beep(800,300)
Write-Host "`n🚀 System cleaned and ready to use!"

# Pause to let you see output
Start-Sleep -Seconds 3
