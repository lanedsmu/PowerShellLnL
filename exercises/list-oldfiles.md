# Listing files older than a particular date

In this exercise, we'll look at creating a reusable script to list files older than a given date.

## Basic listing functionality

Get-childitem (shortcut alias GCI) is the PowerShell tool to use when starting with directories and files.  Let's take a look at what get-childitem can do.

```powershell
get-help get-childitem
NAME
    Get-ChildItem

SYNOPSIS
    Gets the items and child items in one or more specified locations.


SYNTAX
  <snip>
    Get-ChildItem [[-Path] <System.String[]>] [[-Filter] <System.String>] [-Attributes {Archive | Compressed | Device |  
    Directory | Encrypted | Hidden | IntegrityStream | Normal | NoScrubData | NotContentIndexed | Offline | ReadOnly | 
    ReparsePoint | SparseFile | System | Temporary}] [-Depth <System.UInt32>] [-Directory] [-Exclude <System.String[]>]  
    [-File] [-FollowSymlink] [-Force] [-Hidden] [-Include <System.String[]>] [-Name] [-ReadOnly] [-Recurse] [-System]    
    [<CommonParameters>]

DESCRIPTION
    The `Get-ChildItem` cmdlet gets the items in one or more specified locations. If the item is a container, it gets the items inside the container, known as child items. You can use the Recurse parameter to get items in all child containers and use the Depth parameter to limit the number of levels to recurse.

    `Get-ChildItem` doesn't display empty directories. When a `Get-ChildItem` command includes the Depth or Recurse parameters, empty directories aren't included in the output.

    Locations are exposed to `Get-ChildItem` by PowerShell providers. A location can be a file system directory, registry hive, or a certificate store. For more information, see about_Providers (../Microsoft.PowerShell.Core/About/about_Providers.md).

--
get-childitem |get-member

<snip>
   TypeName: System.IO.FileInfo

Name                      MemberType     Definition
----                      ----------     ----------
<snip>
Attributes                Property       System.IO.FileAttributes Attributes {get;set;}
CreationTime              Property       datetime CreationTime {get;set;}
CreationTimeUtc           Property       datetime CreationTimeUtc {get;set;}
Directory                 Property       System.IO.DirectoryInfo Directory {get;}
DirectoryName             Property       string DirectoryName {get;}
Exists                    Property       bool Exists {get;}
Extension                 Property       string Extension {get;}
FullName                  Property       string FullName {get;}
IsReadOnly                Property       bool IsReadOnly {get;set;}
LastAccessTime            Property       datetime LastAccessTime {get;set;}
LastAccessTimeUtc         Property       datetime LastAccessTimeUtc {get;set;}
LastWriteTime             Property       datetime LastWriteTime {get;set;}
LastWriteTimeUtc          Property       datetime LastWriteTimeUtc {get;set;}
Length                    Property       long Length {get;}
```

We've not displayed the whole of the output above, except to note a few things: there are directory and file properties available, and Get-Childitem will show us not only creation time but also last write time and last access time.

For our purposes, we'll look just at the creation time, as we're interested in files that are older than a particular date:

```powershell
Get-ChildItem -Path C:\temp\ -Filter *.* | Where creationTime -lt 2022-02-01
    Directory: C:\temp

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          10/12/2018  6:36 PM                Ai_CS6
-a---            2/3/2019  8:30 PM        4659865 kickoff89022201.jpg
-a---            2/3/2019  8:30 PM        4075804 kickoff890222010.jpg
-a---            2/3/2019  8:30 PM        3677227 kickoff890222011.jpg
-a---            2/3/2019  8:30 PM        5337010 kickoff890222012.jpg
-a---            2/3/2019  8:30 PM        4701222 kickoff890222013.jpg
-a---            2/3/2019  8:30 PM        3555008 kickoff890222014.jpg
-a---            2/3/2019  8:30 PM        2465957 kickoff890222015.jpg
-a---            2/3/2019  8:30 PM        1350243 kickoff890222016.jpg
-a---            2/3/2019  8:30 PM        3373643 kickoff890222017.jpg
-a---            2/3/2019  8:30 PM        3728996 kickoff890222018.jpg
-a---            2/3/2019  8:30 PM        2927592 kickoff890222019.jpg
-a---            2/3/2019  8:30 PM        4409109 kickoff89022202.jpg
-a---            2/3/2019  8:30 PM        3584555 kickoff890222020.jpg
-a---            2/3/2019  8:30 PM        2885081 kickoff890222021.jpg
-a---            2/3/2019  8:30 PM        3459692 kickoff890222022.jpg
-a---            2/3/2019  8:30 PM        2753095 kickoff890222023.jpg
-a---            2/3/2019  8:30 PM        3033922 kickoff890222024.jpg
-a---            2/3/2019  8:30 PM        2598342 kickoff890222025.jpg
-a---            2/3/2019  8:30 PM        2333566 kickoff890222026.jpg
-a---            2/3/2019  8:30 PM        6105305 kickoff89022203.jpg
-a---            2/3/2019  8:30 PM        6105627 kickoff89022204.jpg
-a---            2/3/2019  8:30 PM        3634350 kickoff89022205.jpg
-a---            2/3/2019  8:30 PM        4903027 kickoff89022206.jpg
-a---            2/3/2019  8:30 PM        4419223 kickoff89022207.jpg
-a---            2/3/2019  8:30 PM        4538712 kickoff89022208.jpg
-a---            2/3/2019  8:30 PM        3845857 kickoff89022209.jpg
```

## Delete old files

If we wanted, then, to remove those files, we could do something like this:

```powershell
Get-ChildItem -Path C:\temp\ -Filter *.* | Where creationTime -lt 2022-02-01 | Remove-Item
```

Because PowerShell works on objects, we can pipe the files (objects) to remove-item, and they'll be removed, as well.

## Reusable code

Let's make this script something we can use over and over again by making it:

- Accept parameters at the command line so that changing values don't require editing the script with each execution.
- Contain comment-based help within the script, so that users can use the get-help cmdlet to learn more about the script.

### Parameters

When we're wanting to list files that are older than a certain date, we need to know:

- which files
- what our "old" threshold is

We'll use parameters in the script to gather these from the user at each invocation.

```powershell
param(
    [string]$filePath,
    [datetime]$olderThan
)
Get-ChildItem -Path $filePath -Filter *.* | Where creationTime -lt $olderThan #|remove-item
```

We'll use the variable "filePath" to store the directory we want to clean up.
The "olderThan" variable will store the date we want to use as our cutoff.

The [variableType] format we're using here to explictly cast string and datetime variables isn't strictly speaking necessary, but it helps in two ways:  

1. it makes it clear to anyone who sees the code what is expected
2. it helps to minimize the possibility of erroneous data causing unexpected behavior in our code

We've also commented out the remove-item cmdlet for the time being, as we don't want to be removing things as we're testing our script.

### Filter

Perhaps we don't want to remove _all_ files that are older than a certain date, so let's add a filter parameter, too.  We also need at a minimum to require that a user specify a filePath and a date, so let's make those parameters mandatory.

We'll also specify a default value for the filter parameter, in case that gets left off.

```powershell
param(
    [parameter(mandatory)]
    [string]$filePath,
    [parameter(mandatory)]
    [datetime]$olderThan,
    [string]$filter="*.*"
)
Get-ChildItem -Path $filePath -Filter $filter | Where creationTime -lt $olderThan #|remove-item
```

Now we've got a script that will display files older than a certain date in a given directory, using an optional file filter.

## Confirmation

If we remove the comment from the remove-item, those files will be deleted. Perhaps we want a confirmation before making this happen.  Let's add that to the remove-item cmdlet when we remove the comment character.

```powershell
param(
    [parameter(mandatory)]
    [string]$filePath,
    [parameter(mandatory)]
    [datetime]$olderThan,
    [string]$filter="*.*"
)
Get-ChildItem -Path $filePath -Filter $filter | Where creationTime -lt $olderThan |remove-item -confirm
```

This addition of "-confirm" to our remove-item cmdlet gives us output like this:

```powershell
PS C:\> dir c:\temp\*.log

    Directory: C:\temp

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2/13/2022  8:50 PM            113 testing.log

PS C:\> remove-oldfiles -filePath c:\temp -filter *.log -olderThan 2022-02-14

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove File" on target "C:\temp\testing.log".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

## Comment-based help

Now that we've got our reusable functionality in place, let's add some help text to our script.  This is done using comments within the script file itself.  A downloadable template for that is [here](../comment-based-help.txt), and also displayed below:

```powershell
<#
    .Synopsis
    This does that 
    .Description
    .Example
    Example-
    Example- accomplishes 
    .Parameter <parameterName>
    The parameter
    .Notes
    NAME: Example-
    AUTHOR: $env:username
    LASTEDIT: $(Get-Date)
    KEYWORDS:

    CHANGELOG
        v00.00.00   <Date>  <Author>
            <descr of change>
    .Link
    <wiki.smu.edu/display/ITS/path_to_my_documentation>
#>
```

In our script, we'll use this:

```powershell
<#
    .Synopsis
    Removes files older than a given date in a given path and matching an optional filter 
    .Description
    Uses get-childitem and remove-item (with -confirm, so as to give you a chance to reconsider) to delete files that are older than a particular date in a given directory.
    .Example
    ./remove-oldfiles.ps1 -filePath c:\temp -olderThan 2022-01-01
    Will remove all files (no filter specified) from c:\temp that were created before 1/1/2022 
    .Example
    ./remove-oldfiles.ps1 -filePath /home/laned/ -filter *.log -olderThan 2020-01-01
    Removes all *.log files from /home/laned that were created before 1/1/2020
    .Parameter filePath
    (required) Directory in which to look for and remove files
    .Parameter filter
    (optional) File filter to apply on files in the $filePath directory
    .Parameter olderThan
    (required) Cutoff date: files newer than this date will not be removed.
    .Notes
    NAME: remove-oldfiles
    AUTHOR: Lane Duncan
    LASTEDIT: 2022-02-16

    CHANGELOG
        v01.00.00   2022-02-16  Lane Duncan
            New script with stupendous and flawless functionalty
                (where nothing can possiblye go wrong)
   .Link
    https://github.com/lanedsmu/PowerShellLnL
#>
param(
    [parameter(mandatory)]
    [string]$filePath,
    [parameter(mandatory)]
    [datetime]$olderThan,
    [string]$filter="*.*"
)
Get-ChildItem -Path $filePath -Filter $filter | Where creationTime -lt $olderThan |remove-item -confirm
```

With this comment-based help text, we now can use the get-help cmdlet to see details about our script.

```powershell
PS C:\PowerShellLnL> get-help remove-oldfiles.ps1   

NAME
    remove-oldfiles

SYNOPSIS
    Removes files older than a given date in a given path and matching an optional filter


SYNTAX
    remove-oldfiles [-filePath] <String> [-olderThan] <DateTime> [[-filter] <String>] [<CommonParameters>]


DESCRIPTION
    Uses get-childitem and remove-item (with -confirm, so as to give you a chance to reconsider) to delete files that are older than a particular date in a given directory.

RELATED LINKS
    https://github.com/lanedsmu/PowerShellLnL

REMARKS
    To see the examples, type: "Get-Help remove-oldfiles -Examples"
    For more information, type: "Get-Help remove-oldfiles -Detailed"
    For technical information, type: "Get-Help remove-oldfiles -Full"
    For online help, type: "Get-Help remove-oldfiles -Online"
```
