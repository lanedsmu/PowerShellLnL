# Powershell and You: scripting for a better (less manual) world

## PowerShell: Cross-Platform
Used to be PowerShell was just for Windows.  No longer.

Ubuntu installation instructions: <https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu>

MacOS instatllation instructions:  <https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos>

CENTOS:  <https://docs.microsoft.com/en-us/powershell/scripting/install/install-centos?view=powershell-7.2>

## Random snippets

### Remove files

Remove a single folder

```powershell
PS C:\> remove-item .\foldertodelete -Force
```

Delete from the current directory (*) all files with a .doc file name extension and a name that does not include "1".

```powershell
PS C:\> remove-item * -include *.doc -exclude *1*
```

For more fun, see <https://ss64.com/ps/remove-item.html>

### Executing dynamic commands

Invoke-command with the -scriptBlock argument is very powerful

```powershell
invoke-command -ComputerName$computerName  -ArgumentList $var1,$var2,$var3 -ScriptBlock {cmdlet-or-function-name -param $var1-param2 $var2 -param3 $var3
    param($var1, $var2, $var3)
}
```

Path and/or script name can be specified using variables using this method.

```powershell
invoke-expression "$($pathvar)scriptname.ps1 -scriptParm1 $($parmVar1)"
```


### Run .ps1 script on three computers simultaneously

This is neat, because it executes the local c:\utils\testLocalUtil.ps1 script on the three remote computers at the same time. Results are returned to the local computer

```powershell
invoke-command -computerName Computer1.smuedu, Computer2.smu.edu, Computer3.smu.edu-filePath c:\utils\testLocalUtil.ps1
```

### Run a script block on remote computers simultaneously

```powershell
invoke-command -computername Computer1.smuedu, Computer2.smu.edu, Computer3.smu.edu -scriptBlock {get-childitem c:\}
```

### Run a script block on remote computers in series

```powershell
$computers ="computer1.smu.edu","computer2.smu.edu","computer3.smu.edu"
foreach ($computer in $computers)
{
    invoke-command -computername $computer -scriptblock {Get-ChildItem -Path c:\test -recurse -Include *.txt -Exclude *.exe |Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-30) }| remove-item}
}
```

More fun:  <https://ss64.com/ps/invoke-command.html>

## Data files

### import a CSV

```powershell
import-csv -path ./samples/sample4.csv 
```

### select just a particiular subset of values from a csv file

```powershell
import-csv -path ./samples/sample4.csv | Select-String "Length=29"
```

### convert csv to json

```powershell
import-csv -path ./samples/sample4.csv | convertfrom-json
```
