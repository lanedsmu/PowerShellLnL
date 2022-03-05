# Powershell and You: scripting for a better (less manual) world

Table of contents

- [Installation](#installation)
- [Basic usage](#basics)
- [Active Directory Information](#active-directory-information)
- [CSVs and JSON](#csv-and-json-files)
- [Writing your own](#writing-your-own-scripts)
- [Examples](#random-snippets)
  - [Remoting](#run-ps1-script-on-three-computers-simultaneously)
  - [CSV and JSON Data files](#data-files)

## Installation

Used to be PowerShell was just for Windows.  No longer.

<https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell>

Install latest version (if you already have PowerShell installed):
<https://aka.ms/install-powershell.ps1>

(For those interested in what that script might do, you can see it all here:  <https://github.com/PowerShell/PowerShell/blob/master/tools/install-powershell.ps1>)

```powershell
# Ampersand char is "call" character.  See <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.1#call-operator->
# expression below will launch a new PowerShell installer
invoke-expression "& { $(invoke-restMethod https://aka.ms/install-powershell.ps1) }"
# add -UseMSI for Windows systems: invoke-expression "& { $(invoke-restMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
```

MacOS installation instructions:  <https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos>

Ubuntu installation instructions: <https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu>

CENTOS:  <https://docs.microsoft.com/en-us/powershell/scripting/install/install-centos?view>

## Basics

PowerShell commands are a verb ("get", "invoke", etc.) and a noun ("member","expression").
Get-Member is a very good example, and it's a command that can be very helpful in understanding what other commands do.

Below we'll pipe the get-uptime cmdlet to get-member.  More a few more details on get-member and exploring PowerShell commands can be found [here](./getMemberInfo.md).

get-uptime, below, is a function available in later versions of Powershell. Make sure you've installed the latest before trying to execute this command.

```powershell
get-uptime | get-member 
```

Pro tip: when typing on the command line, CTRL Space will give you a list of possible switches and options that you can choose from dynamically.

```powershell
PS C:\git\PowerShellLnL> Send-MailMessage -{CTRL SPACE HERE}
Attachments                 Priority                    ErrorAction
Bcc                         ReplyTo                     WarningAction
Body                        Subject                     InformationAction
BodyAsHtml                  To                          ErrorVariable
Encoding                    Credential                  WarningVariable
Cc                          UseSsl                      InformationVariable
DeliveryNotificationOption  Port                        OutVariable
From                        Verbose                     OutBuffer
SmtpServer                  Debug                       PipelineVariable

[string[]] Attachments
```

## Active Directory information

Powershell (on Windows) has the ability to display and operate on domain objects

```powershell
get-aduser -identity xxxx 
```

```powershell
get-adgroup -identity xxxx
```

For more details on active directory objects and cmdlets, see [this page](./ADObjectUtils/readme.md).

## CSV and JSON files

Powershell has built-in csv and json parsing:

```powershell
get-content ./sampleDataFiles/sample4.csv | convertfrom-csv
```

```powershell
get-content ./sampleDataFiles/myJsonSettingsFile.json | convertfrom-json
```

## Writing your own scripts

The biggest reason to script work is to make it repeatable with accuracy and relative ease.
One big step in doing this is to write scripts that provide documentation within the script itself and that will accept parameters at the command line.

<mark>Start with our list-oldfiles script</mark> [here](./exercises/list-oldfiles.md).

Learn how to export to a CSV file from Excel (and operate on Excel data) [here](./exercises/convertFrom-excel2csv.md).

Create a Windows reboot-at script [here](./exercises/reboot-at.md).

### Comment-based help

Powershell scripts and functions can use comment-based help (template [here](./comment-based-help.txt) to guide output from get-help.  Add that text to the top of a script to make it much easier for others to understand how to use it.

See the reboot-at walkthrough linked above for a concrete example of using comment-based help.

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

Invoke-command with the -scriptBlock argument is very powerful. Note that this defaults to Windows remote management, but it's wholly possible to set up PowerShell to use SSH-based remoting for true cross-platform functionality.  (Note: sudo introduces some wrinkles in ssh-based remoting that aren't handled entirely gracefully.)

```powershell
invoke-command -ComputerName $computerName -ArgumentList $var1,$var2,$var3 -ScriptBlock {cmdlet-or-function-name -param $var1 -param2 $var2 -param3 $var3
    param($var1, $var2, $var3)
}
```

Path and/or script name can be specified using variables using this method.

```powershell
invoke-expression "$($pathvar)scriptname.ps1 -scriptParm1 $($parmVar1)"
```

### Run .ps1 script on three computers simultaneously

This is neat, because it executes the local c:\utils\testLocalUtil.ps1 script on the three remote computers at the same time--in parallel. Results are returned to the local computer

```powershell
invoke-command -computerName Computer1.smu.edu, Computer2.smu.edu, Computer3.smu.edu -filePath c:\utils\testLocalUtil.ps1
```

### Run a script block on remote computers simultaneously

```powershell
invoke-command -computername Computer1.smu.edu, Computer2.smu.edu, Computer3.smu.edu -scriptBlock 
{    
    get-childitem c:\ 
    # and any other statements/scripts you'd like to run 
}
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
import-csv -path ./sampleDataFiles/sample4.csv | Select-String "Length=29"
```

Here's another way to do accomplish something similarly, formatted differently. The differences in formatting are due to the differences in how where-object and select-string work.  

```powershell
get-content -path ./sampleDataFiles/sample4.csv| convertfrom-csv |Where-Object "Game Length" -eq 78
```

Note that the above get-content command works identically when reading a json file and using the convertfrom-json cmdlet.

### convert csv to json

```powershell
import-csv -path ./samples/sample4.csv | convertto-json
```
