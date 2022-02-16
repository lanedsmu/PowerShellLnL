<#
.SYNOPSIS
    Reboots a computer at a specified date and time
.DESCRIPTION
    uses the Windows shutdown.exe application with the /t timer switch to reboot a computer at a specified date and time.
.PARAMETER computerName
    (optional) If specified, reboots the remote computer <computerName>
.PARAMETER RestartTime
    (mandatory) The time (required) and date (optional) to reboot the computer.  If the time only is specified, the date is assumed to be the current date.
.EXAMPLE
    ./reboot-at -RestartTime "8PM"
        restarts the local host at 8:00pm today
.EXAMPLE
    ./reboot-at -computerName mysrv.smu.edu -RestartTime "2022-02-14 7:43pm"
        restarts the host "mysrv.smu.edu" at 7:43pm on 2/14/2022
.NOTES
    FunctionName : reboot-at.ps1
    Version: 1.00.00
    Created by   : Lane Duncan
    Date Coded   : 2/14/2022
.LINK
    https://wiki.smu.edu/display/ITS/Powershell+Cmdlets+and+Scripts
#>
param(
    [parameter()]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime
)
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds

$rebootParams = @("/t $($WaitSeconds)", "/r"
)
if ($PSBoundParameters.ContainsKey("computerName")) {
    $rebootParams.Add("/m \\$($computerName)")
}
Start-Process shutdown -ArgumentList $rebootParams