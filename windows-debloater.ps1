<#
.SYNOPSIS
    Windows Ultimate Debloater
.DESCRIPTION
    Run directly: irm https://raw.githubusercontent.com/Amo-n-ymous/windows-debloater/main/debloater.ps1 | iex
#>

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Get the full command line that invoked this script
$fullCommand = [Environment]::CommandLine

# Parse parameters from command line
$RemoveStore = $fullCommand -match "-RemoveStore"
$NoRestorePoint = $fullCommand -match "-NoRestorePoint"

Write-Host "=== WINDOWS ULTIMATE DEBLOATER ===" -ForegroundColor Red
Write-Host "Parameters detected:" -ForegroundColor Cyan
Write-Host "RemoveStore: $RemoveStore" -ForegroundColor Cyan
Write-Host "NoRestorePoint: $NoRestorePoint" -ForegroundColor Cyan

# Admin check
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and 'Run as Administrator'" -ForegroundColor Yellow
    timeout /t 5
    exit
}

# Countdown
Write-Host "`nStarting in 3 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Create restore point
if (-not $NoRestorePoint) {
    Write-Host "Creating system restore point..." -ForegroundColor Green
    try {
        Checkpoint-Computer -Description "Pre-Debloat" -RestorePointType MODIFY_SETTINGS
        Write-Host "Restore point created!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create restore point" -ForegroundColor Red
    }
}

# Remove bloatware apps
Write-Host "`nRemoving bloatware apps..." -ForegroundColor Yellow

$apps = @(
    "Microsoft.BingWeather",
    "Microsoft.GetHelp", 
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.XboxApp",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.SkypeApp",
    "Microsoft.Teams"
)

# Add Store apps if RemoveStore is true
if ($RemoveStore) {
    $apps += "Microsoft.WindowsStore"
    $apps += "Microsoft.StorePurchaseApp"
    Write-Host "Microsoft Store will be removed" -ForegroundColor Red
} else {
    Write-Host "Microsoft Store will be kept" -ForegroundColor Green
}

foreach ($app in $apps) {
    try {
        Get-AppxPackage "*$app*" | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$app*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "Removed: $app" -ForegroundColor Green
    } catch {
        Write-Host "Failed: $app" -ForegroundColor Red
    }
}

# Disable services
Write-Host "`nDisabling services..." -ForegroundColor Yellow
$services = @("XboxGipSvc", "XboxNetApiSvc", "DiagTrack", "dmwappushservice")
foreach ($service in $services) {
    try {
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "Disabled: $service" -ForegroundColor Green
    } catch {
        Write-Host "Failed to disable: $service" -ForegroundColor Red
    }
}

# Remove OneDrive
Write-Host "`nRemoving OneDrive..." -ForegroundColor Yellow
taskkill /f /im OneDrive.exe > $null 2>&1
Start-Sleep -Seconds 2

# Final output
Write-Host "`n=== DEBLOATING COMPLETE ===" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor White
Write-Host "- Removed all bloatware apps" -ForegroundColor White
Write-Host "- Removed OneDrive" -ForegroundColor White  
Write-Host "- Disabled telemetry services" -ForegroundColor White
if ($RemoveStore) { Write-Host "- REMOVED Microsoft Store" -ForegroundColor Red } else { Write-Host "- Kept Microsoft Store" -ForegroundColor Green }
if (-not $NoRestorePoint) { Write-Host "- Created restore point" -ForegroundColor Green } else { Write-Host "- No restore point created" -ForegroundColor Yellow }

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
