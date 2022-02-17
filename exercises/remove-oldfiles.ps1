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
    Default:  "*.*"
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
    [string]$filter = "*.*"
)
Get-ChildItem -Path $filePath -Filter $filter | Where-Object creationTime -LT $olderThan |Remove-Item -Confirm