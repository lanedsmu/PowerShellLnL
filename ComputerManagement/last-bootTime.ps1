# get-uptime was introduced in PowerShell 6
$PSVersionTable
get-host

Get-Uptime

Get-CimInstance -ClassName win32_operatingsystem | Select-Object csname, lastbootuptime

# take a look at all the things you can see using this OS class
Get-CimInstance -classname Win32_OperatingSystem 

