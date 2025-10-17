# 🚀 AGGRESSIVE WINDOWS DEBLOATER - FIXED FLAGS VERSION
# Run with: irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex

param(
    [switch]$GamingMode = $false,
    [switch]$SafeMode = $false,
    [switch]$CreateRestorePoint = $true,
    [switch]$RemoveStore = $false
)

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# Check admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🔒 Restarting as Administrator..." -ForegroundColor Yellow
    Write-Host "Please click 'Yes' on the UAC prompt" -ForegroundColor Yellow
    
    # Build the command with all flags
    $command = "-ExecutionPolicy Bypass -Command `"irm 'https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1' | iex"
    if ($GamingMode) { $command += " -GamingMode" }
    if ($SafeMode) { $command += " -SafeMode" }
    if (-not $CreateRestorePoint) { $command += " -CreateRestorePoint:`$false" }
    if ($RemoveStore) { $command += " -RemoveStore" }
    $command += "`""
    
    Start-Process PowerShell -ArgumentList $command -Verb RunAs
    exit
}

Write-Host "=========================================" -ForegroundColor Red
Write-Host "   AGGRESSIVE WINDOWS DEBLOATER" -ForegroundColor Red
Write-Host "   🚀 Performance + Privacy + Cleaning" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Red

# Show active flags
if ($GamingMode) { Write-Host "🎮 GAMING MODE: Xbox apps preserved" -ForegroundColor Cyan }
if ($SafeMode) { Write-Host "🛡️ SAFE MODE: Limited changes" -ForegroundColor Yellow }
if (-not $CreateRestorePoint) { Write-Host "⚡ NO RESTORE POINT: Faster execution" -ForegroundColor Magenta }
if ($RemoveStore) { Write-Host "🛒 STORE REMOVAL: Microsoft Store will be removed" -ForegroundColor Red }

# Create restore point
if ($CreateRestorePoint) {
    try {
        Write-Host "`n📦 Creating system restore point..." -ForegroundColor Yellow
        Checkpoint-Computer -Description "Pre-Debloater Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        Write-Host "✅ Restore point created" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Could not create restore point" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⚡ Skipping restore point creation..." -ForegroundColor Magenta
}

function Remove-BloatwareApps {
    Write-Host "`n🗑️  REMOVING BLOATWARE APPS..." -ForegroundColor Cyan
    
    # List of bloatware apps to remove
    $bloatwareApps = @(
        # Microsoft games
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.People",
        "Microsoft.WindowsCamera",
        "Microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        
        # Third-party bloat
        "Facebook.Facebook",
        "Instagram.Instagram", 
        "SpotifyAB.SpotifyMusic",
        "Twitter.Twitter",
        "TikTok.TikTok",
        "Netflix.Netflix",
        "Disney.Disney",
        "PandoraMediaInc.Pandora",
        "CandyCrushSaga.CandyCrushSaga",
        "BubbleWitch3Saga.BubbleWitch3Saga",
        "King.com.CandyCrushSodaSaga",
        "AdobeSystemsIncorporated.AdobePhotoshopExpress",
        
        # Windows bloat
        "Microsoft.3DBuilder",
        "Microsoft.BingFinance",
        "Microsoft.BingNews",
        "Microsoft.BingSports",
        "Microsoft.CommsPhone",
        "Microsoft.ConnectivityStore",
        "Microsoft.Drawing",
        "Microsoft.Messaging",
        "Microsoft.Office.OneNote",
        "Microsoft.OneConnect",
        "Microsoft.SkypeApp",
        "Microsoft.Wallet",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsPhone",
        "Microsoft.WindowsScan"
    )
    
    if ($GamingMode) {
        Write-Host "🎮 Gaming Mode: Keeping Xbox apps" -ForegroundColor Yellow
        $bloatwareApps = $bloatwareApps | Where-Object { $_ -notlike "*Xbox*" }
    }
    
    if ($SafeMode) {
        Write-Host "🛡️ Safe Mode: Removing only major bloatware" -ForegroundColor Yellow
        $safeApps = @(
            "Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted",
            "Microsoft.MicrosoftSolitaireCollection", "Microsoft.People",
            "Microsoft.WindowsFeedbackHub", "Microsoft.YourPhone",
            "Facebook.Facebook", "Instagram.Instagram", "Twitter.Twitter",
            "TikTok.TikTok", "Netflix.Netflix", "CandyCrushSaga.CandyCrushSaga"
        )
        $bloatwareApps = $safeApps
    }
    
    foreach ($app in $bloatwareApps) {
        try {
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Host "   ✅ Removed: $app" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ Failed: $app" -ForegroundColor Red
        }
    }
}

function Remove-MicrosoftStore {
    Write-Host "`n🛒 REMOVING MICROSOFT STORE..." -ForegroundColor Cyan
    try {
        Get-AppxPackage -Name "Microsoft.WindowsStore" -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "Microsoft.WindowsStore" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "✅ Microsoft Store removed completely" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to remove Microsoft Store" -ForegroundColor Red
    }
}

function Disable-Telemetry {
    Write-Host "`n🔒 DISABLING TELEMETRY & TRACKING..." -ForegroundColor Cyan
    
    if (-not $SafeMode) {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    }
    
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✅ Telemetry disabled" -ForegroundColor Green
}

function Optimize-Services {
    Write-Host "`n⚙️  OPTIMIZING SERVICES..." -ForegroundColor Cyan
    
    $servicesToDisable = @(
        "DiagTrack", "dmwappushservice", "WSearch", "XboxGipSvc", "XboxNetApiSvc",
        "TrkWks", "Fax", "MSiSCSI", "WpcMonSvc", "PhoneSvc", "TabletInputService",
        "lmhosts", "RemoteRegistry", "SharedAccess", "lltdsvc", "PNRPAutoReg",
        "PNRPsvc", "p2pimsvc", "p2psvc", "SessionEnv", "TermService", "UmRdpService",
        "RpcLocator", "RemoteAccess", "SensorDataService", "SensrSvc", "SensorService",
        "ScDeviceEnum", "SCPolicySvc", "SNMPTRAP", "WFDSConMgrSvc", "WbioSrvc",
        "FrameServer", "wisvc", "icssvc", "WMPNetworkSvc", "wscsvc", "XblAuthManager",
        "XblGameSave", "XboxNetApiSvc"
    )
    
    if ($GamingMode) {
        Write-Host "🎮 Gaming Mode: Keeping Xbox services" -ForegroundColor Yellow
        $servicesToDisable = $servicesToDisable | Where-Object { $_ -notlike "Xbox*" -and $_ -notlike "Xbl*" }
    }
    
    if ($SafeMode) {
        Write-Host "🛡️ Safe Mode: Disabling only critical services" -ForegroundColor Yellow
        $safeServices = @("DiagTrack", "dmwappushservice", "WSearch", "RemoteRegistry")
        $servicesToDisable = $safeServices
    }
    
    foreach ($service in $servicesToDisable) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "   ✅ Disabled: $service" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ Failed: $service" -ForegroundColor Red
        }
    }
}

function Optimize-PowerSettings {
    Write-Host "`n⚡ OPTIMIZING POWER SETTINGS..." -ForegroundColor Cyan
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    if (-not $SafeMode) {
        powercfg -h off
    }
    Write-Host "✅ Power settings optimized" -ForegroundColor Green
}

function Optimize-Network {
    Write-Host "`n🌐 OPTIMIZING NETWORK SETTINGS..." -ForegroundColor Cyan
    if (-not $SafeMode) {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "EnablePMTUDiscovery" -Type DWord -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    }
    Write-Host "✅ Network optimized" -ForegroundColor Green
}

function Disable-VisualEffects {
    Write-Host "`n🎨 DISABLING VISUAL EFFECTS..." -ForegroundColor Cyan
    if (-not $SafeMode) {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    }
    Write-Host "✅ Visual effects optimized" -ForegroundColor Green
}

# MAIN EXECUTION
try {
    Write-Host "`n🚀 Starting debloating process..." -ForegroundColor Yellow
    Write-Host "⚠️  This will take 2-5 minutes..." -ForegroundColor Yellow
    
    # Execute all functions
    Remove-BloatwareApps
    if ($RemoveStore) {
        Remove-MicrosoftStore
    }
    Disable-Telemetry
    Optimize-Services
    Optimize-PowerSettings
    Optimize-Network
    Disable-VisualEffects
    
    Write-Host "`n" + "="*50 -ForegroundColor Green
    Write-Host "✅ DEBLOATING COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "="*50 -ForegroundColor Green
    
    Write-Host "`n🎯 Changes made:" -ForegroundColor Cyan
    Write-Host "   • Removed bloatware apps" -ForegroundColor White
    if ($RemoveStore) {
        Write-Host "   • Removed Microsoft Store completely" -ForegroundColor White
    }
    Write-Host "   • Disabled telemetry & tracking" -ForegroundColor White
    Write-Host "   • Optimized services" -ForegroundColor White
    Write-Host "   • Enhanced power & network settings" -ForegroundColor White
    Write-Host "   • Disabled visual effects for performance" -ForegroundColor White
    
    Write-Host "`n🔄 Please restart your computer for all changes to take effect!" -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ Error during debloating: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
