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