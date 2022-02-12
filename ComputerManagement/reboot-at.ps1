<#
   .Synopsis
    Reboots a Windows computer at a specified time, using the OS shutdown.exe command.
    .DESCRIPTION
    Restart-at uses the -t switch of the shutdown.exe Windows utility to set a countdown timer for a reboot.
    The timer is calculated as the number of seconds between the date provided in the -restartTime parameter and the current time.
   .EXAMPLE
    reboot-at -restartTime 8pm
    restarts the local computer at 8:00pm tonight
    .EXAMPLE
    reboot-at -computerName MyServer.smu.edu -restartTime "2022-2-14 2:16am"
    restarts remote computer MyServer.smu.edu at 2:16am on 2/14/2022
   .Parameter computerName
    Name of the remote computer to restart
    .Parameter restartTime
    Date (optional) and time (mandatory) to restart the computer
   .Notes
    NAME: restart-at
    VERSION: 1.0
    AUTHOR: Lane Duncan
    LASTEDIT: 2/12/2022

    CHANGELOG:
        v.1.00  20220212    Lane Duncan
            New script check in

   .Link
    <wiki.smu.edu/display/ITS/path_to_my_documentation>
#>
param(
    [string]$computerName,
    [parameter(Mandatory)]
    [string]$restartTime
)

[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
[string]$shutdownArgs=" /r /t $($WaitSeconds)"
if ($PSBoundParameters.ContainsKey($computerName))
{
    $shutdownArgs+=" /m \\\\$($computerName)"
}
shutdown $shutdownArgs