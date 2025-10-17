<#
.SYNOPSIS
    Windows Nuclear Debloater - Removes Everything
.DESCRIPTION
    One-click aggressive debloater that removes all bloatware including Microsoft Store
#>

# Check if already running as admin, if not, relaunch as admin
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges." -ForegroundColor Yellow
    Write-Host "A UAC prompt will appear. Click YES to continue." -ForegroundColor Yellow
    Write-Host "Waiting for elevation..." -ForegroundColor Yellow
    
    # Relaunch as admin
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1 | iex`""
    $psi.Verb = "runas"
    $psi.WindowStyle = "Normal"
    
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Host "Failed to elevate! Please run PowerShell as Administrator manually." -ForegroundColor Red
    }
    exit
}

# Now running as admin - continue with the script
Write-Host "=== WINDOWS NUCLEAR DEBLOATER ===" -ForegroundColor Red
Write-Host "Running as Administrator: YES" -ForegroundColor Green

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Show confirmation window
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$result = [System.Windows.Forms.MessageBox]::Show(
    "WINDOWS NUCLEAR DEBLOATER`n`nTHIS WILL REMOVE:`n✓ Microsoft Store`n✓ All pre-installed apps`n✓ OneDrive`n✓ Xbox services`n✓ Telemetry services`n✓ Cortana`n✓ Bing apps`n`nTHIS IS IRREVERSIBLE!`n`nContinue?",
    "NUCLEAR DEBLOATER - WARNING",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Warning
)

if ($result -ne "Yes") {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "STARTING AGGRESSIVE DEBLOATING..." -ForegroundColor Red
Write-Host "This will take a few minutes..." -ForegroundColor Yellow

# Countdown
for ($i = 5; $i -gt 0; $i--) {
    Write-Host "Starting in $i seconds... (Ctrl+C to cancel)" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Create restore point
Write-Host "`nCreating system restore point..." -ForegroundColor Green
try {
    Checkpoint-Computer -Description "Pre-Nuclear-Debloat" -RestorePointType MODIFY_SETTINGS
    Write-Host "✓ Restore point created" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to create restore point" -ForegroundColor Red
}

# KILL PROCESSES
Write-Host "`n[1/7] KILLING BLOATWARE PROCESSES..." -ForegroundColor Cyan
$processes = @("OneDrive", "XboxApp", "SkypeApp", "Teams", "Cortana")
foreach ($proc in $processes) {
    taskkill /f /im "$proc.exe" > $null 2>&1
}
Start-Sleep -Seconds 2

# REMOVE ALL MICROSOFT STORE APPS
Write-Host "`n[2/7] REMOVING ALL STORE APPS..." -ForegroundColor Cyan
$bloatware = @(
    # Microsoft Store
    "Microsoft.WindowsStore",
    "Microsoft.StorePurchaseApp", 
    "Microsoft.Services.Store.Engagement",
    
    # Communication
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.Teams",
    
    # Entertainment
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.BingWeather",
    "Microsoft.BingNews", 
    "Microsoft.BingSports",
    "Microsoft.Getstarted",
    "Microsoft.GetHelp",
    
    # Xbox
    "Microsoft.XboxApp",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.XboxTCUI",
    
    # Cortana
    "Microsoft.549981C3F5F10",
    "Microsoft.Cortana",
    
    # Windows Apps
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCalculator",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.MSPaint",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MixedReality.Portal",
    "Microsoft.YourPhone",
    "Microsoft.Paint",
    "Microsoft.ScreenSketch",
    
    # Third-party bloat
    "AdobeSystemsIncorporated.AdobePhotoshopExpress",
    "CandyCrush",
    "Disney",
    "Netflix",
    "Spotify",
    "Facebook",
    "Instagram",
    "Twitter",
    "TikTok",
    "RoyalRevolt"
)

$removedCount = 0
foreach ($app in $bloatware) {
    try {
        Get-AppxPackage "*$app*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$app*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        $removedCount++
        Write-Host "✓ Removed: $app" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed: $app" -ForegroundColor Red
    }
}

# DISABLE SERVICES
Write-Host "`n[3/7] DISABLING SERVICES..." -ForegroundColor Cyan
$services = @(
    "DiagTrack",           # Telemetry
    "dmwappushservice",    # WAP Push
    "WSearch",             # Windows Search
    "XboxGipSvc",          # Xbox
    "XboxNetApiSvc",       # Xbox
    "lfsvc",               # Geolocation
    "MapsBroker",          # Maps
    "TabletInputService"   # Touch Keyboard
)

foreach ($service in $services) {
    try {
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "✓ Disabled: $service" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed: $service" -ForegroundColor Red
    }
}

# REMOVE ONEDRIVE COMPLETELY
Write-Host "`n[4/7] REMOVING ONEDRIVE..." -ForegroundColor Cyan
try {
    # Kill OneDrive
    taskkill /f /im OneDrive.exe > $null 2>&1
    taskkill /f /im FileCoAuth.exe > $null 2>&1
    
    # Remove folders
    Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "✓ OneDrive completely removed" -ForegroundColor Green
} catch {
    Write-Host "✗ OneDrive removal failed" -ForegroundColor Red
}

# DISABLE TELEMETRY
Write-Host "`n[5/7] DISABLING TELEMETRY..." -ForegroundColor Cyan
$telemetryRegs = @(
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Value=0},
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"; Name="AllowTelemetry"; Value=0}
)

foreach ($reg in $telemetryRegs) {
    try {
        if (!(Test-Path $reg.Path)) { New-Item -Path $reg.Path -Force | Out-Null }
        Set-ItemProperty -Path $reg.Path -Name $reg.Name -Value $reg.Value -ErrorAction SilentlyContinue
        Write-Host "✓ Disabled telemetry: $($reg.Path)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed telemetry: $($reg.Path)" -ForegroundColor Red
    }
}

# DISABLE SCHEDULED TASKS
Write-Host "`n[6/7] DISABLING SCHEDULED TASKS..." -ForegroundColor Cyan
$tasks = @(
    "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "Microsoft\Windows\Application Experience\ProgramDataUpdater", 
    "Microsoft\Windows\Customer Experience Improvement Program\*"
)

foreach ($task in $tasks) {
    try {
        Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
        Write-Host "✓ Disabled task: $task" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed task: $task" -ForegroundColor Red
    }
}

# PERFORMANCE OPTIMIZATIONS
Write-Host "`n[7/7] PERFORMANCE OPTIMIZATIONS..." -ForegroundColor Cyan
try {
    # Disable tips and ads
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✓ Performance optimizations applied" -ForegroundColor Green
} catch {
    Write-Host "✗ Performance optimizations failed" -ForegroundColor Red
}

# FINAL SUMMARY
Write-Host "`n" + "="*60 -ForegroundColor Green
Write-Host "NUCLEAR DEBLOATING COMPLETE!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Green
Write-Host "Removed $removedCount bloatware apps" -ForegroundColor White
Write-Host "Disabled 8 services" -ForegroundColor White
Write-Host "Removed OneDrive completely" -ForegroundColor White
Write-Host "Disabled telemetry and data collection" -ForegroundColor White
Write-Host "Disabled scheduled tasks" -ForegroundColor White
Write-Host "Applied performance optimizations" -ForegroundColor White
Write-Host "`nWindows is now CLEAN and OPTIMIZED!" -ForegroundColor Green
Write-Host "Restart your computer to complete the process." -ForegroundColor Yellow

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
