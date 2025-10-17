# Windows Ultimate Debloater

Aggressive Windows debloater for maximum performance.

## Quick Install

**Administrator PowerShell required:**

# Remove everything INCLUDING Microsoft Store, NO restore point
    irm "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1?RemoveStore&NoRestorePoint" | iex

# Remove everything INCLUDING Microsoft Store, WITH restore point  
    irm "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1?RemoveStore" | iex

# Remove bloatware but KEEP Microsoft Store, NO restore point
    irm "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1?NoRestorePoint" | iex

# Remove bloatware but KEEP Microsoft Store, WITH restore point (DEFAULT)
    irm "https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1" | iex


Features

  - Removes all pre-installed bloatware

  - Disables telemetry and data collection

  - Removes OneDrive completely

  - Disables unnecessary services

  - Performance optimizations


    ⚠️ Use at your own risk! Always create a backup first.
