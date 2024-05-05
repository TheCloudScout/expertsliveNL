[CmdletBinding()]
param (
    [Parameter (Mandatory = $false)]
    [String] $baseDirectory = "C:\WINDOWS\TEMP\INVESTIGATIONS"
)

## Global variables ##
# Dynamic DMP filename, based on Hostname and Date and Time
$filename = "memorydump.raw"

# Set Working directory to C:\Windows\Temp
Set-Location -Path C:\Windows\Temp
New-Item -ItemType Directory -Path $baseDirectory -Force

# Free disk space overhead multiplier
$DiskOverhead = 1.2 # 20% overhead assumed for disk space calculation.

# Get current User Principal
$user = [Security.Principal.WindowsIdentity]::GetCurrent();

# Winpmem Split File
$SplitDump = $False # If $True dump will be split into multiple files
$SplitChunkSize = "200m" # Size per memory dump chunk. Written as winpmem requires
# Script Main

if ((New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $False) {
    Write-Sub-Error "Session not elevated. Exiting."
    return
    }
# Check if required disk space is available
$Memsize=(Get-WmiObject win32_physicalmemory).capacity -as [long]
$DiskFree=(Get-WmiObject win32_logicaldisk -Filter "DeviceID='C:'").freespace -as [long]

if ($Diskfree -le $Memsize * $DiskOverhead) {
    Write-Sub-Error ("Not Enough Disk Space. Exiting.") -ForegroundColor Red
    return
    }
# Get Winpmem binaries

$repo = "Velocidex/WinPmem"
$filenamePattern = "*x64*.exe"
$releases = "https://api.github.com/repos/$repo/releases"

$releasesUri = "https://api.github.com/repos/$repo/releases/latest"
$downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $filenamePattern ).browser_download_url
Invoke-WebRequest $downloadUri -OutFile winpmem.exe
# Dump Device Memory
# Please note that this will fail in virtual machines that use dynamic memory
if ($SplitDump -eq $False) {
    .\winpmem.exe "$baseDirectory\$filename"
}
else {
    Write-Status "Dumping memory in $SplitChunkSize byte chunks"
    .\winpmem.exe "$baseDirectory\$filename" --split $SplitChunkSize
}