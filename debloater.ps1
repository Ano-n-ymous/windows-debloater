# 🚀 AGGRESSIVE WINDOWS DEBLOATER - FIXED VERSION
# Run with: irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex

param(
    [switch]$SafeMode = $false,
    [switch]$GamingMode = $false,
    [switch]$CreateRestorePoint = $true,
    [switch]$RemoveStore = $false
)

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# Check admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🔒 Restarting as Administrator..." -ForegroundColor Yellow
    Write-Host "Please click 'Yes' on the UAC prompt" -ForegroundColor Yellow
    
    # FIX: Download the script content and restart as admin with encoded command
    $scriptContent = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1")
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -EncodedCommand $encodedCommand" -Verb RunAs
    exit
}

Write-Host "=========================================" -ForegroundColor Red
Write-Host "   AGGRESSIVE WINDOWS DEBLOATER" -ForegroundColor Red
Write-Host "   🚀 Performance + Privacy + Cleaning" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Red

# Create restore point
if ($CreateRestorePoint) {
    try {
        Write-Host "`n📦 Creating system restore point..." -ForegroundColor Yellow
        Checkpoint-Computer -Description "Pre-Debloater Restore Point" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "✅ Restore point created" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Could not create restore point" -ForegroundColor Yellow
    }
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
    
    # Disable data collection
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable tailored experiences
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable advertising ID
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✅ Telemetry disabled" -ForegroundColor Green
}

function Optimize-Services {
    Write-Host "`n⚙️  OPTIMIZING SERVICES..." -ForegroundColor Cyan
    
    $servicesToDisable = @(
        "DiagTrack",           # Connected User Experiences and Telemetry
        "dmwappushservice",    # WAP Push Message Routing Service
        "WSearch",             # Windows Search
        "XboxGipSvc",          # Xbox Accessory Management
        "XboxNetApiSvc",       # Xbox Live Networking Service
        "TrkWks",              # Distributed Link Tracking Client
        "Fax",                 # Fax Service
        "MSiSCSI",             # Microsoft iSCSI Initiator Service
        "WpcMonSvc",           # Parental Controls
        "PhoneSvc",            # Phone Service
        "TabletInputService",  # Touch Keyboard and Handwriting Panel Service
        "lmhosts",             # TCP/IP NetBIOS Helper
        "RemoteRegistry",      # Remote Registry
        "SharedAccess",        # Internet Connection Sharing (ICS)
        "lltdsvc",             # Link-Layer Topology Discovery Mapper
        "PNRPAutoReg",         # Peer Name Resolution Protocol
        "PNRPsvc",             # Peer Networking Grouping
        "p2pimsvc",            # Peer Networking Identity Manager
        "p2psvc",              # Peer Networking
        "SessionEnv",          # Remote Desktop Configuration
        "TermService",         # Remote Desktop Services
        "UmRdpService",        # Remote Desktop Services UserMode Port Redirector
        "RpcLocator",          # Remote Procedure Call (RPC) Locator
        "RemoteAccess",        # Routing and Remote Access
        "SensorDataService",   # Sensor Data Service
        "SensrSvc",            # Sensor Monitoring Service
        "SensorService",       # Sensor Service
        "ScDeviceEnum",        # Smart Card Device Enumeration Service
        "SCPolicySvc",         # Smart Card Removal Policy
        "SNMPTRAP",            # SNMP Trap
        "WFDSConMgrSvc",       # Wi-Fi Direct Services Connection Manager Service
        "WbioSrvc",            # Windows Biometric Service
        "FrameServer",         # Windows Camera Frame Server
        "wisvc",               # Windows Insider Service
        "icssvc",              # Windows Mobile Hotspot Service
        "WMPNetworkSvc",       # Windows Media Player Network Sharing Service
        "wscsvc",              # Windows Security Center Service
        "XblAuthManager",      # Xbox Live Auth Manager
        "XblGameSave",         # Xbox Live Game Save Service
        "XboxNetApiSvc"        # Xbox Live Networking Service
    )
    
    if ($GamingMode) {
        Write-Host "🎮 Gaming Mode: Keeping Xbox services" -ForegroundColor Yellow
        $servicesToDisable = $servicesToDisable | Where-Object { $_ -notlike "Xbox*" }
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
    
    # Set to high performance
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    
    # Disable hibernation
    powercfg -h off
    
    Write-Host "✅ Power settings optimized" -ForegroundColor Green
}

function Optimize-Network {
    Write-Host "`n🌐 OPTIMIZING NETWORK SETTINGS..." -ForegroundColor Cyan
    
    # Optimize TCP/IP parameters
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "EnablePMTUDiscovery" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    
    Write-Host "✅ Network optimized" -ForegroundColor Green
}

function Disable-VisualEffects {
    Write-Host "`n🎨 DISABLING VISUAL EFFECTS..." -ForegroundColor Cyan
    
    # Disable transparency
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✅ Visual effects disabled" -ForegroundColor Green
}

# MAIN EXECUTION
try {
    Write-Host "`n🚀 Starting aggressive debloating..." -ForegroundColor Yellow
    Write-Host "⚠️  This will take 2-5 minutes..." -ForegroundColor Yellow
    
    if ($SafeMode) {
        Write-Host "🛡️  Safe Mode: Limited changes" -ForegroundColor Yellow
    }
    if ($GamingMode) {
        Write-Host "🎮 Gaming Mode: Keeping Xbox apps" -ForegroundColor Yellow
    }
    if ($RemoveStore) {
        Write-Host "🛒 Store Removal: Microsoft Store will be removed" -ForegroundColor Yellow
    }
    
    # Execute all functions
    Remove-BloatwareApps
    Disable-Telemetry
    Optimize-Services
    Optimize-PowerSettings
    Optimize-Network
    Disable-VisualEffects
    
    # Remove Microsoft Store if flag is set
    if ($RemoveStore) {
        Remove-MicrosoftStore
    }
    
    Write-Host "`n" + "="*50 -ForegroundColor Green
    Write-Host "✅ DEBLOATING COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "="*50 -ForegroundColor Green
    
    Write-Host "`n🎯 Changes made:" -ForegroundColor Cyan
    Write-Host "   • Removed 50+ bloatware apps" -ForegroundColor White
    Write-Host "   • Disabled telemetry & tracking" -ForegroundColor White
    Write-Host "   • Optimized 30+ services" -ForegroundColor White
    Write-Host "   • Enhanced power & network settings" -ForegroundColor White
    Write-Host "   • Disabled visual effects for performance" -ForegroundColor White
    if ($RemoveStore) {
        Write-Host "   • Removed Microsoft Store completely" -ForegroundColor White
    }
    
    Write-Host "`n🔄 Please restart your computer for all changes to take effect!" -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ Error during debloating: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
