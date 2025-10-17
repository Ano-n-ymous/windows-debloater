# Windows Ultimate Debloater

Aggressive Windows debloater for maximum performance.

## Quick Install

**Administrator PowerShell required:**

# Remove everything including Microsoft Store (no restore point)
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1 | iex -RemoveStore -NoRestorePoint

# Remove all bloatware but keep Microsoft Store
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1 | iex

# Remove all bloatware including Store
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/windows-debloater.ps1 | iex -RemoveStore

Parameters

  - RemoveStore: Removes Microsoft Store completely

  - NoRestorePoint: Skips creating a system restore point

Features

  - Removes all pre-installed bloatware

  - Disables telemetry and data collection

  - Removes OneDrive completely

  - Disables unnecessary services

  - Performance optimizations


    ⚠️ Use at your own risk! Always create a backup first.
