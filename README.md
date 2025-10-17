# 🚀 AGGRESSIVE WINDOWS DEBLOATER

> **The ultimate PowerShell script to reclaim your system's performance, privacy, and peace of mind.**

![Windows Debloater](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows)
![PowerShell](https://img.shields.io/badge/PowerShell-Script-5391FE?style=for-the-badge&logo=powershell)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## ✨ Features

- 🗑️ **Remove 50+ Bloatware Apps** - Candy Crush, Xbox bloat, TikTok, Netflix, and more
- 🔒 **Disable Telemetry & Tracking** - Enhanced privacy protection
- ⚙️ **Optimize 30+ Services** - Disable non-essential background services
- ⚡ **Boost Performance** - Power plans, network tuning, and visual effects
- 🎮 **Gaming Mode** - Preserves Xbox services for gamers
- 🛡️ **Safe Mode** - Limited changes for cautious users
- 📦 **Auto-Restore Point** - Safety first with automatic backup

## 🚀 Quick Start

### Method 1: One-Line Install (Recommended)

    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex

# What Each Flag Does:
SafeMode:

- Removes only the most aggressive bloatware

- Keeps essential Windows features

- Less service optimization

- Safer for beginners

GamingMode:

- Keeps all Xbox-related apps and services

- Preserves Game Bar, Xbox app, gaming overlays

- Still removes other bloatware

- Ideal for gamers

 CreateRestorePoint:$false:

- Skips creating system restore point

- Faster execution

- Not recommended for first-time users

# Full aggressive debloat with Microsoft Store removed and no restore point(Perfect for experienced users who want maximum control and speed):
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex -RemoveStore -CreateRestorePoint:$false

# Gaming PC optimization 
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex -GamingMode

# Safe mode for testing
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex -SafeMode

# Full aggressive debloat
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex
# Full aggressive debloat No Restore Point:
    irm https://raw.githubusercontent.com/Ano-n-ymous/windows-debloater/main/debloater.ps1 | iex -CreateRestorePoint:$false

  # 📋 What Gets Removed?
🎮 Microsoft Apps

  1. Bing Weather, Get Help, Get Started

  2. Microsoft Solitaire Collection

  3. People, Windows Camera, Mail & Calendar

  4. Windows Feedback Hub, Maps, Sound Recorder

  5. Your Phone, Zune Music & Video

## ❌ Third-Party Bloatware

  6. Facebook, Instagram, TikTok

  7. spotify, Netflix, Disney+

  8. Candy Crush Saga & other games

  9. Adobe Photoshop Express

## 🛠️ System Apps

  10. 3D Builder, Bing Finance/News/Sports

  11. Communications, Messaging, OneConnect

  12. Skype, Wallet, Windows Scan

## ⚡ Performance Optimizations
Services Disabled

  1. DiagTrack - Connected User Experiences and Telemetry

  2. WSearch - Windows Search (disables file indexing)

  3. XboxGipSvc - Xbox Accessory Management

  4. TrkWks - Distributed Link Tracking Client

  5. RemoteRegistry - Remote Registry access

  6. And 25+ more non-essential services

## System Tweaks

  🚀 High-performance power plan activated

  💤 Hibernation disabled (saves disk space)

  🌐 Network optimizations for faster TCP/IP

  🎨 Visual effects disabled for better performance

  📊 Telemetry completely disabled

## 🛡️ Safety Features

  ✅ Automatic restore point creation

  ✅ Administrator check - auto-elevates if needed

  ✅ Error handling - continues on individual failures

  ✅ Transparent process - see what's being modified

  ✅ Gaming Mode - preserves gaming functionality

## ⚠️ Important Notes

  1. Requires Administrator rights - script will auto-elevate

  2. Restart required after running for all changes to take effect

  3. Some Store functionality may be affected

  4. Gaming Mode keeps Xbox services intact

  5. Safe Mode makes minimal changes for testing

  6.Backup important data before running

## 🔧 Customization

You can easily modify the script to suit your needs:

  1. Edit $bloatwareApps array to add/remove apps

  2. Modify $servicesToDisable list for services

  3. Adjust registry tweaks in the functions

  4. Comment out sections you don't want to run

## ❓ FAQ
🤔 Is this safe?

Yes, with precautions. The script creates a restore point and has been tested, but always backup important data.
🔄 Can I revert changes?

Use the system restore point created by the script, or reinstall removed apps from Microsoft Store.
🎮 What does Gaming Mode do?

Preserves all Xbox-related apps and services for optimal gaming performance.
💻 Which Windows versions are supported?

Windows 10 and Windows 11, all editions.
⏱️ How long does it take?

Typically 2-5 minutes depending on your system.
📱 Will this break Windows Store?

Some Store functionality may be affected as we remove Microsoft bloatware apps.
🐛 Reporting Issues

Found a bug or have a suggestion? Open an issue on GitHub.
🤝 Contributing

## Contributions are welcome! Feel free to:

  Report bugs and issues

  Suggest new features

  Submit pull requests

  Improve documentation

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
⚠️ Disclaimer

This software is provided "as is" without warranty of any kind. Use at your own risk. The authors are not responsible for any damage to your system.

⭐ If this project helped you, please give it a star on GitHub!







