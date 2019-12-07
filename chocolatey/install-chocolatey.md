
# How to Install Chocolatey

Chocolatey is the goto Windows package manager for DevOps command line (scripting) professionals.

The steps to install chocolatey through the **`Powershell`** CLI are to

- click on the Windows start button and type Powershell
- click the arrow on Windows PowerShell and Run as administrator
- Run **`Get-ExecutionPolicy`**
- if it returns Restricted, then run **`Set-ExecutionPolicy AllSigned`** or **`Set-ExecutionPolicy Bypass -Scope Process`**
- run this command - **`Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`**

Now chocolatey should be installed.

