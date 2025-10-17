# Windows Ultimate Debloater

Aggressive Windows debloater for maximum performance.

## Quick Install

**Administrator PowerShell required:**

```powershell
# Remove everything including Microsoft Store (no restore point)
irm https://raw.githubusercontent.com/YourUsername/windows-debloater/main/windows-debloater.ps1 | iex -RemoveStore -NoRestorePoint

# Remove all bloatware but keep Microsoft Store
irm https://raw.githubusercontent.com/YourUsername/windows-debloater/main/windows-debloater.ps1 | iex

# Remove all bloatware including Store
irm https://raw.githubusercontent.com/YourUsername/windows-debloater/main/windows-debloater.ps1 | iex -RemoveStore
