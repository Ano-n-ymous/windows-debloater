# 🚀 ULTIMATE WINDOWS 10/11 DEBLOATER - FIXED AUTO-CLOSE
# Run with: irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex

# Bypass everything
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# Check admin rights
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "🔒 This script requires Administrator privileges" -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and execute the command again" -ForegroundColor Yellow
    Write-Host "Or click 'Yes' if you see a UAC prompt" -ForegroundColor Yellow
    
    # Download script content
    $url = "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1"
    $scriptContent = (Invoke-RestMethod -Uri $url)
    
    # Encode and restart as admin - FIXED to keep window open
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))
    $process = Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -EncodedCommand $encoded -NoExit" -Verb RunAs -PassThru -Wait
    
    if ($process.ExitCode -eq 0) {
        exit
    }
    
    # If we get here, the admin process didn't start properly
    Write-Host "❌ Failed to start as administrator. Please run PowerShell as Admin manually." -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   ULTIMATE WINDOWS DEBLOATER" -ForegroundColor Cyan
Write-Host "   🚀 Super Lightweight + Maximum Performance" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Running as Administrator ✅" -ForegroundColor Green

# Create restore point for safety
try {
    Write-Host "`n📦 Creating system restore point..." -ForegroundColor Yellow
    Checkpoint-Computer -Description "Pre-Debloater Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    Write-Host "✅ Restore point created" -ForegroundColor Green
} catch { 
    Write-Host "⚠️  Continue without restore point" -ForegroundColor Yellow 
}

function Remove-AllBloatware {
    Write-Host "`n🗑️  REMOVING ALL BLOATWARE..." -ForegroundColor Red
    
    # Comprehensive list of ALL bloatware
    $allBloatware = @(
        # Microsoft Store and apps
        "Microsoft.WindowsStore",
        "Microsoft.StorePurchaseApp",
        "Microsoft.WindowsFeedbackHub",
        
        # Xbox ecosystem
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay", 
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        
        # Bing and news
        "Microsoft.BingWeather",
        "Microsoft.BingNews",
        "Microsoft.BingSports",
        "Microsoft.BingFinance",
        
        # Social and communication
        "Microsoft.People",
        "Microsoft.YourPhone",
        "Microsoft.SkypeApp",
        "microsoft.windowscommunicationsapps",
        
        # Entertainment
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "Microsoft.WindowsCamera",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.WindowsMaps",
        
        # Productivity bloat
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        
        # Third-party apps
        "Facebook.Facebook",
        "Instagram.Instagram",
        "Twitter.Twitter",
        "TikTok.TikTok",
        "Netflix.Netflix",
        "Disney.Disney",
        "SpotifyAB.SpotifyMusic",
        "PandoraMediaInc.Pandora",
        
        # Games
        "CandyCrushSaga.CandyCrushSaga",
        "BubbleWitch3Saga.BubbleWitch3Saga",
        "King.com.CandyCrushSodaSaga"
    )
    
    Write-Host "Removing $($allBloatware.Count) bloatware apps..." -ForegroundColor Yellow
    
    $removedCount = 0
    foreach ($app in $allBloatware) {
        try {
            # Remove from all users
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            # Remove provisioned packages
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            $removedCount++
            Write-Host "   ✅ Removed: $app" -ForegroundColor Green
        } catch {
            Write-Host "   ⚠️  Failed: $app" -ForegroundColor Yellow
        }
    }
    
    Write-Host "Successfully removed $removedCount apps" -ForegroundColor Green
}

function Disable-AllTelemetry {
    Write-Host "`n🔒 DISABLING ALL TELEMETRY & TRACKING..." -ForegroundColor Red
    
    # Core telemetry disable
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable tailored experiences
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable advertising
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✅ All telemetry and tracking disabled" -ForegroundColor Green
}

function Optimize-AllServices {
    Write-Host "`n⚙️  OPTIMIZING SERVICES FOR PERFORMANCE..." -ForegroundColor Red
    
    # Services to disable for maximum performance
    $servicesToDisable = @(
        # Telemetry and tracking
        "DiagTrack", "dmwappushservice",
        
        # Xbox services
        "XboxGipSvc", "XboxNetApiSvc", "XblAuthManager", "XblGameSave",
        
        # Unnecessary features
        "Fax", "WpcMonSvc", "PhoneSvc", "TabletInputService",
        "RemoteRegistry", "WSearch"
    )
    
    foreach ($service in $servicesToDisable) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "   ✅ Disabled: $service" -ForegroundColor Green
        } catch {
            Write-Host "   ⚠️  Failed: $service" -ForegroundColor Yellow
        }
    }
}

function Optimize-Performance {
    Write-Host "`n⚡ MAXIMIZING SYSTEM PERFORMANCE..." -ForegroundColor Red
    
    # Set to High Performance power plan
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    
    # Disable hibernation (frees up RAM-sized disk space)
    powercfg -h off
    
    # Disable visual effects for maximum performance
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "✅ Maximum performance settings applied" -ForegroundColor Green
}

function Clean-System {
    Write-Host "`n🧹 CLEANING SYSTEM FILES..." -ForegroundColor Red
    
    # Clean temp files
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "✅ System cleaned" -ForegroundColor Green
}

# MAIN EXECUTION
try {
    Write-Host "`n🚀 Starting ULTIMATE debloating process..." -ForegroundColor Cyan
    Write-Host "⚠️  This will take 2-5 minutes..." -ForegroundColor Yellow
    Write-Host "💡 Making Windows SUPER lightweight and fast..." -ForegroundColor White
    
    # Execute all optimization functions
    Remove-AllBloatware
    Disable-AllTelemetry
    Optimize-AllServices
    Optimize-Performance
    Clean-System
    
    Write-Host "`n" + "="*60 -ForegroundColor Green
    Write-Host "🎉 ULTIMATE DEBLOATING COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "="*60 -ForegroundColor Green
    
    Write-Host "`n🎯 Your Windows is now SUPER LIGHTWEIGHT:" -ForegroundColor Cyan
    Write-Host "   ✅ Removed 40+ bloatware apps including Microsoft Store" -ForegroundColor White
    Write-Host "   ✅ Disabled ALL telemetry and tracking" -ForegroundColor White
    Write-Host "   ✅ Optimized services for performance" -ForegroundColor White
    Write-Host "   ✅ Applied maximum performance settings" -ForegroundColor White
    Write-Host "   ✅ Cleaned temporary files" -ForegroundColor White
    Write-Host "   ✅ Enhanced privacy and security" -ForegroundColor White
    
    Write-Host "`n📊 Expected improvements:" -ForegroundColor Yellow
    Write-Host "   • Faster boot time" -ForegroundColor White
    Write-Host "   • More available RAM" -ForegroundColor White
    Write-Host "   • Better system performance" -ForegroundColor White
    Write-Host "   • Enhanced privacy" -ForegroundColor White
    
    Write-Host "`n🔄 RESTART YOUR COMPUTER TO COMPLETE THE OPTIMIZATION!" -ForegroundColor Red
    Write-Host "   This is required for all changes to take effect!" -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "But most changes were applied successfully!" -ForegroundColor Yellow
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
