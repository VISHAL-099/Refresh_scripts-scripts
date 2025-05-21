# CPU Temp (if supported via WMI or 3rd party)
Write-Host "[CPU] Temperature: Checking..." -ForegroundColor Cyan
try {
    $cpuTemp = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | Select-Object -First 1
    if ($cpuTemp) {
        $tempC = ($cpuTemp.CurrentTemperature - 2732) / 10
        Write-Host "[CPU] Temperature: $tempC °C"
    } else {
        Write-Host "[CPU] Temperature: Not available"
    }
} catch {
    Write-Host "[CPU] Temperature: Not accessible"
}

# Battery status
$battery = Get-WmiObject Win32_Battery
if ($battery) {
    Write-Host "[Battery] Status: $($battery.BatteryStatus), Charge: $($battery.EstimatedChargeRemaining)%"
} else {
    Write-Host "[Battery] Not detected"
}

# WiFi signal strength
$wifi = netsh wlan show interfaces | Select-String 'Signal'
if ($wifi) {
    $signal = ($wifi -split ':')[1].Trim()
    Write-Host "[Wi-Fi] Signal Strength: $signal"
} else {
    Write-Host "[Wi-Fi] Not connected"
}

# System Errors
Write-Host "[System Check] Errors in last 24h:"
$errors = Get-WinEvent -LogName System -ErrorAction SilentlyContinue | Where-Object { $_.LevelDisplayName -eq "Error" -and $_.TimeCreated -gt (Get-Date).AddHours(-24) }

if ($errors -and $errors.Count -gt 0) {
    Write-Host "[!] Errors found: $($errors.Count)" -ForegroundColor Red
} else {
    Write-Host "[OK] No system errors found in last 24h" -ForegroundColor Green
}
