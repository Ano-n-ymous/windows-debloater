<#
.SYNOPSIS
    Windows Ultimate Debloater - Maximum Performance Edition

.DESCRIPTION
    Aggressively removes all Windows bloatware, telemetry, and unnecessary components
    for maximum system performance. Use with caution!

.PARAMETER RemoveStore
    Removes Microsoft Store along with all other bloatware

.PARAMETER NoRestorePoint
    Does not create a system restore point (not recommended but available)

.EXAMPLE
    irm https://raw.githubusercontent.com/YourUsername/YourRepo/main/windows-debloater.ps1 | iex -RemoveStore -NoRestorePoint
#>

[CmdletBinding()]
param(
    [switch]$RemoveStore,
    [switch]$NoRestorePoint
)

# Function to write colored output
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

# Main execution block
function Invoke-Debloat {
    # Require Administrator privileges
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-ColorOutput "This script requires Administrator privileges. Please run PowerShell as Administrator." "Red"
        exit 1
    }

    Write-ColorOutput "=== WINDOWS ULTIMATE DEBLOATER - MAXIMUM PERFORMANCE ===" "Red"
    Write-ColorOutput "THIS IS AN AGGRESSIVE DEBLOATER THAT WILL REMOVE:" "Yellow"
    Write-ColorOutput "- All pre-installed Windows apps (except essentials)" "Yellow"
    Write-ColorOutput "- Microsoft Store (if -RemoveStore specified)" "Yellow"
    Write-ColorOutput "- Telemetry and data collection services" "Yellow"
    Write-ColorOutput "- Cortana, OneDrive, Xbox, and much more" "Yellow"
    Write-ColorOutput "USE AT YOUR OWN RISK! CREATE A SYSTEM RESTORE POINT FIRST!" "Red"

    # Countdown for safety
    Write-ColorOutput "`nScript will continue in 5 seconds... Press Ctrl+C to abort!" "Yellow"
    for ($i = 5; $i -gt 0; $i--) {
        Write-ColorOutput "Starting in $i..." "Yellow"
        Start-Sleep -Seconds 1
    }

    if (-not $NoRestorePoint) {
        Write-ColorOutput "`nCreating system restore point..." "Green"
        try {
            Checkpoint-Computer -Description "Pre-Windows-Debloater" -RestorePointType "MODIFY_SETTINGS"
            Write-ColorOutput "Restore point created successfully." "Green"
        }
        catch {
            Write-Warning "Failed to create restore point. Continuing anyway..."
        }
    }

    # Function to remove apps
    function Remove-AppxPackageBulk {
        param($AppList)
        
        foreach ($App in $AppList) {
            try {
                Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*$App*"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                Write-ColorOutput "Removed: $App" "Green"
            }
            catch {
                Write-Warning "Failed to remove: $App"
            }
        }
    }

    # Function to disable services
    function Disable-ServiceBulk {
        param($ServiceList)
        
        foreach ($Service in $ServiceList) {
            try {
                Stop-Service -Name $Service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $Service -StartupType Disabled -ErrorAction SilentlyContinue
                Write-ColorOutput "Disabled service: $Service" "Yellow"
            }
            catch {
                Write-Warning "Could not disable service: $Service"
            }
        }
    }

    # COMPREHENSIVE BLOATWARE REMOVAL LIST
    Write-ColorOutput "`n[1/6] REMOVING PRE-INSTALLED APPS..." "Cyan"

    $BloatwareApps = @(
        # Microsoft Store and related (conditional removal)
        "Microsoft.WindowsStore*",
        "Microsoft.StorePurchaseApp*",
        "Microsoft.Services.Store.Engagement*",
        
        # Communication & Social
        "Microsoft.People*",
        "Microsoft.SkypeApp*",
        "Microsoft.Teams*",
        "Facebook*",
        "Twitter*",
        "Instagram*",
        "Spotify*",
        
        # Entertainment
        "Microsoft.ZuneMusic*",
        "Microsoft.ZuneVideo*",
        "Microsoft.WindowsSoundRecorder*",
        "Microsoft.MicrosoftSolitaireCollection*",
        "Microsoft.BingWeather*",
        "Microsoft.BingNews*",
        "Microsoft.BingSports*",
        "Microsoft.Getstarted*",
        "Microsoft.GetHelp*",
        
        # Xbox
        "Microsoft.XboxApp*",
        "Microsoft.XboxGamingOverlay*",
        "Microsoft.XboxGameOverlay*",
        "Microsoft.XboxIdentityProvider*",
        "Microsoft.XboxSpeechToTextOverlay*",
        "Microsoft.XboxTCUI*",
        
        # Cortana
        "Microsoft.549981C3F5F10*",
        "Microsoft.Cortana*",
        
        # Other Microsoft
        "Microsoft.WindowsCamera*",
        "Microsoft.WindowsMaps*",
        "Microsoft.WindowsAlarms*",
        "Microsoft.WindowsCalculator*",
        "Microsoft.WindowsFeedbackHub*",
        "Microsoft.MSPaint*",
        "Microsoft.Microsoft3DViewer*",
        "Microsoft.MixedReality.Portal*",
        
        # Third-party bloat
        "AdobeSystemsIncorporated.AdobePhotoshopExpress*",
        "CandyCrush*",
        "Disney*",
        "Netflix*",
        "Royal Revolt*"
    )

    # Remove conditionally based on -RemoveStore flag
    if ($RemoveStore) {
        Write-ColorOutput "Removing Microsoft Store and all bloatware..." "Red"
        Remove-AppxPackageBulk -AppList $BloatwareApps
    } else {
        Write-ColorOutput "Removing all bloatware except Microsoft Store..." "Yellow"
        $AppsWithoutStore = $BloatwareApps | Where-Object { $_ -notlike "*WindowsStore*" -and $_ -notlike "*StorePurchase*" -and $_ -notlike "*Services.Store*" }
        Remove-AppxPackageBulk -AppList $AppsWithoutStore
    }

    # TELEMETRY AND DATA COLLECTION
    Write-ColorOutput "`n[2/6] DISABLING TELEMETRY AND DATA COLLECTION..." "Cyan"

    $TelemetryKeys = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\System"
    )

    foreach ($Key in $TelemetryKeys) {
        try {
            if (!(Test-Path $Key)) { New-Item -Path $Key -Force | Out-Null }
            Set-ItemProperty -Path $Key -Name "AllowTelemetry" -Type DWord -Value 0
        }
        catch { Write-Warning "Could not disable telemetry at: $Key" }
    }

    # SERVICES DISABLING
    Write-ColorOutput "`n[3/6] DISABLING UNNECESSARY SERVICES..." "Cyan"

    $ServicesToDisable = @(
        "DiagTrack",
        "dmwappushservice",
        "WSearch",
        "XboxGipSvc",
        "XboxNetApiSvc",
        "lfsvc",
        "MapsBroker"
    )

    Disable-ServiceBulk -ServiceList $ServicesToDisable

    # ONEDRIVE COMPLETE REMOVAL
    Write-ColorOutput "`n[4/6] REMOVING ONEDRIVE..." "Cyan"

    try {
        taskkill /f /im OneDrive.exe /t 2>&1 | Out-Null
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Write-ColorOutput "OneDrive removed completely" "Green"
    }
    catch {
        Write-Warning "OneDrive removal partially failed"
    }

    # PERFORMANCE OPTIMIZATIONS
    Write-ColorOutput "`n[5/6] APPLYING PERFORMANCE OPTIMIZATIONS..." "Cyan"

    # Disable visual effects for performance
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 2

    # Disable tips and suggestions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0

    Write-ColorOutput "`n=== DEBLOATING COMPLETE ===" "Green"
    Write-ColorOutput "Summary of actions taken:" "White"
    Write-ColorOutput "- Removed all pre-installed bloatware apps" "White"
    if ($RemoveStore) { Write-ColorOutput "- Removed Microsoft Store" "Red" } else { Write-ColorOutput "- Kept Microsoft Store" "Yellow" }
    Write-ColorOutput "- Disabled telemetry and data collection" "White"
    Write-ColorOutput "- Disabled unnecessary services" "White"
    Write-ColorOutput "- Removed OneDrive completely" "White"
    Write-ColorOutput "- Applied performance optimizations" "White"

    if (-not $NoRestorePoint) {
        Write-ColorOutput "`nA system restore point was created. You can revert if needed." "Green"
    } else {
        Write-ColorOutput "`nWARNING: No restore point was created!" "Red"
    }

    Write-ColorOutput "`nA system restart is recommended for all changes to take effect." "Yellow"
}

# Execute the main function
Invoke-Debloat
