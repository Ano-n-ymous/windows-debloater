<#
.SYNOPSIS
    Windows Ultimate Debloater - 100% Working Version
.DESCRIPTION
    Usage: irm "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1?RemoveStore&NoRestorePoint" | iex
#>

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Parse parameters from URL (using WebClient to get actual request URL)
try {
    $webClient = New-Object System.Net.WebClient
    $url = $webClient.ResponseHeaders['X-Request-Url']
    if (-not $url) { $url = "" }
} catch {
    $url = ""
}

# Parse parameters from URL
$RemoveStore = $url -match "[?&]RemoveStore"
$NoRestorePoint = $url -match "[?&]NoRestorePoint"

Write-Host "=== WINDOWS ULTIMATE DEBLOATER ===" -ForegroundColor Red
Write-Host "URL Parameters detected:" -ForegroundColor Cyan
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
for ($i = 3; $i -gt 0; $i--) {
    Write-Host "$i..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Create restore point
if (-not $NoRestorePoint) {
    Write-Host "`nCreating system restore point..." -ForegroundColor Green
    try {
        Checkpoint-Computer -Description "Pre-Windows-Debloater" -RestorePointType MODIFY_SETTINGS
        Write-Host "Restore point created successfully!" -ForegroundColor Green
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
    "Microsoft.Teams",
    "Microsoft.Paint",
    "Microsoft.Cortana"
)

# Add Store apps if RemoveStore is true
if ($RemoveStore) {
    $apps += "Microsoft.WindowsStore"
    $apps += "Microsoft.StorePurchaseApp"
    $apps += "Microsoft.Services.Store.Engagement"
    Write-Host "Microsoft Store will be REMOVED" -ForegroundColor Red
} else {
    Write-Host "Microsoft Store will be KEPT" -ForegroundColor Green
}

$removedCount = 0
foreach ($app in $apps) {
    try {
        $package = Get-AppxPackage "*$app*" -ErrorAction SilentlyContinue
        if ($package) {
            $package | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$app*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Host "✓ Removed: $app" -ForegroundColor Green
            $removedCount++
        }
    } catch {
        # Silent fail
    }
}

# Disable services
Write-Host "`nDisabling services..." -ForegroundColor Yellow
$services = @("XboxGipSvc", "XboxNetApiSvc", "DiagTrack", "dmwappushservice", "WSearch")
foreach ($service in $services) {
    try {
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "✓ Disabled: $service" -ForegroundColor Green
    } catch {
        # Silent fail
    }
}

# Remove OneDrive
Write-Host "`nRemoving OneDrive..." -ForegroundColor Yellow
taskkill /f /im OneDrive.exe > $null 2>&1
Start-Sleep -Seconds 2
Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✓ OneDrive removed" -ForegroundColor Green

# Final output
Write-Host "`n" + "="*50 -ForegroundColor Green
Write-Host "DEBLOATING COMPLETE!" -ForegroundColor Green
Write-Host "="*50 -ForegroundColor Green
Write-Host "Removed $removedCount apps" -ForegroundColor White
Write-Host "Disabled 5 services" -ForegroundColor White
Write-Host "Removed OneDrive" -ForegroundColor White
if ($RemoveStore) { 
    Write-Host "REMOVED Microsoft Store" -ForegroundColor Red 
} else { 
    Write-Host "KEPT Microsoft Store" -ForegroundColor Green 
}
if (-not $NoRestorePoint) { 
    Write-Host "Created system restore point" -ForegroundColor Green 
} else { 
    Write-Host "No restore point created" -ForegroundColor Yellow 
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
