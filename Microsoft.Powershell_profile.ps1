# import module
Import-Module PSReadLine

# Persistent History
# Save last 200 history items on exit
$MaximumHistoryCount = 200  
$historyPath = Join-Path (split-path $profile) history.clixml

# Hook powershell's exiting event & hide the registration with -supportevent (from nivot.org)
Register-EngineEvent -SourceIdentifier powershell.exiting -SupportEvent -Action {
    Get-History -Count $MaximumHistoryCount | Export-Clixml (Join-Path (split-path $profile) history.clixml) 
}

# Load previous history, if it exists
if ((Test-Path $historyPath)) {
    Import-Clixml $historyPath | ? {$count++;$true} | Add-History
    Write-Host -Fore Green "`nLoaded $count history item(s).`n"
}

# Aliases and functions to make it useful
#Set-Alias -Name i -Value Invoke-History -Description "Invoke history alias"
#Rename-Item Alias:\h original_h -Force
function h { Get-History -c  $MaximumHistoryCount }
function hg($arg) { Get-History -c $MaximumHistoryCount | out-string -stream | select-string $arg }

# Set Linux bash like autocomplete
# https://stackoverflow.com/questions/8264655/how-to-make-powershell-tab-completion-work-like-bash
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Aliases
Set-Alias -Name which -Value get-command
Set-Alias -Name ifconfig -Value ipconfig
Set-Alias l Get-ChildItem
Set-Alias ll Get-ChildItem

Set-Alias -Name python3 -Value "C:\Python36\python.exe"
Set-Alias -Name pip3 -Value "C:\Python36\Scripts\pip.exe"
Set-Alias -Name ipython3 -Value "C:\Python36\Scripts\ipython.exe"

Set-Alias -Name python2 -Value "C:\Python27\python.exe"
Set-Alias -Name pip2 -Value "C:\Python27\Scripts\pip.exe"
Set-Alias -Name ipython2 -Value "C:\Python27\Scripts\ipython.exe"

Set-Alias -Name python -Value "python3"
Set-Alias -Name ipython -Value "ipython3"
Set-Alias -Name pip -Value "pip3"
