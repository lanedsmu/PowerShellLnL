<#
.SYNOPSIS
    Reboots a computer at a specified date and time
.DESCRIPTION
    uses the Windows shutdown.exe application with the /t timer switch to reboot a computer at a specified date and time.
    uses the Linux shutdown application with the +<min> timer switch to reboot a computer at a specified time
.PARAMETER computerName
    (optional) If specified, reboots the remote computer <computerName>
.PARAMETER RestartTime
    (mandatory) The time (required) and date (optional) to reboot the computer.  If the time only is specified, the date is assumed to be the current date.
.PARAMETER Linux
    (optional) If "-Linux" is specified at the command line, use remote pssession to reboot a remote Linux/MacOS computer
.EXAMPLE
    ./reboot-at -RestartTime "8PM"
        restarts the local host at 8:00pm today
.EXAMPLE
    ./reboot-at -computerName mysrv.smu.edu -RestartTime "2022-02-14 7:43pm"
        restarts the host "mysrv.smu.edu" at 7:43pm on 2/14/2022
.NOTES
    FunctionName : reboot-at.ps1
    Version: 1.05.00
    Created by   : Lane Duncan
    Date Coded   : 2/14/2022

    CHANGELOG
        v1.05.00    20220216    Lane Duncan
            Added Linux check and remote pssession
.LINK
    https://wiki.smu.edu/display/ITS/Powershell+Cmdlets+and+Scripts
#>
param(
    [parameter()]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime,
    [switch]$Linux
    )
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
if ($Linux) # Linux/MacOS 
{
    if (-not($PSBoundParameters.ContainsKey("comoputerName"))){
        $computerName="."
    }
    $rebootParams = @("-r +$([int]$($waitseconds /60))")
    $session = New-PSSession -Computername $($computerName)
    Invoke-Command -ScriptBlock {"shutdown"} -ArgumentList $rebootParams -Session $session
}
else # Windows
{
    $rebootParams = @("/t $($WaitSeconds)", "/r")
    if ($PSBoundParameters.ContainsKey("computerName")) {
        $rebootParams.Add("/m \\$($computerName)")
    }
    Start-Process shutdown -ArgumentList $rebootParams
}
