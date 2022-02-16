# Writing a reusable script

On this page

- [Reusable Statements](#making-statements-reusable)
- [Sample reboot-at.ps1 script](#reboot-atps1)
- [Dynamic parameters](#array-parameters)
- [Bonus exercise challenge](#bonus-exercise)
- [Adding Documentation](#documentation-and-help)
- [Comment-based help template](#help-template)

We'll start with a simple and useful set of commands to reboot a Windows computer at a particular time:

```powershell
[datetime]$RestartTime = '8PM'
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
shutdown -r -t $WaitSeconds
```

What this does is calculate the number of seconds between the desired reboot time and now, and then it calls the Windows shutdown.exe command with the -t switch to have it delay that number of seconds.

There are a few things to note about these statements:

- using the <mark>[objectType]</mark> modifier tells PowerShell what kind of datatype the string will be.  In this case, we're casting two strings ('8PM' and the current date) as dateTime elements, and one string as an integer.
- DateTime data types have a <mark>.TotalSeconds</mark> property.
- We can call a command using a variable as a switch or parameter value.

## Making statements reusable 

Reusable functions have a couple of characteristics in common:

- Accept parameters at the command line so that changing values don't require editing the script with each execution.
- [Comment-based help](./cbh/HelpText.md) within the script, so that users can use the <mark>get-help</mark> cmdlet to learn more about the script.

### Reboot-at.ps1

Here we'll take our collection of commands at the top and turn them into a functioning script that we can use to reboot Windows computers remotely.

#### Parameters

In order to accept parameters on the command line, we need to tell the script what those parameters will be. 

```powershell
param(
    [string]$computerName,
    [datetime]$RestartTime
)
```

This block tells our script that we'll accept two values: computerName, and RestartTime.  One is a string, and the other is a dateTime data type.

We have a decision to make here: we certainly want to require a RestartTime value; do we also want to require a computerName?

To make a parameter mandatory, we add the <mark>[parameter(mandatory)]</mark> modifier before the parameter definition.

```powershell
param(
    [parameter(mandatory)]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime
)
```

#### Remote Reboot Script block

Now that we've got our parameters, we can plug them in to the commands we have at the top.

```powershell
param(
    [parameter(mandatory)]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime
)
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
shutdown /r /t $WaitSeconds /m "\\$($computerName)"
```

#### Array parameters 

What if, instead of requiring our script to be run against a local computer, we wanted to make it more flexible, so that it could be run either against a local or remote system?

While there are a variety of ways to handle this, one of the most straightforward is the use of an <mark>array</mark> for the shutdown.exe parameters.

An array is just a list of values, and the basic format to create one is like this:

```powershell
@(
keyName = "value"
keyName2 = 4
)
```

So for our reboot-at command, we might use an array like this:

```powershell
$rebootParams=@(
"/t $($WaitSeconds)"
"/r"
)
```

The benefit of putting our shutdown parameters in an arrays is that it makes it much easier to add parameters conditionally, such that we can do something like this:

```powershell
param(
    [parameter()]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime
)
$rebootParams=@(
"/t $($WaitSeconds)"
"/r"
)
if ($PSBoundParameters.ContainsKey("computerName")) 
{
    $rebootParams.Add("/m \\$($computerName)")
}
```

Here we've checked to see if the "computerName" parameter was specified, and if it was, we add the <mark>"/m \\computername"</mark> switch to the array.

Now we can call the shutdown.exe application, passing the $rebootParams array to it through the powershell -argumentList switch.

### Functional script

The full script to this point, then, looks like this:

```powershell
param(
    [parameter()]
    [string]$computerName,
    [parameter(mandatory)]
    [datetime]$RestartTime
)
$rebootParams=@(
"/t $($WaitSeconds)"
"/r"
)
if ($PSBoundParameters.ContainsKey("computerName"))
{
    $rebootParams.Add("/m \\$($computerName)")
}
start-process shutdown -arg $rebootParams
```

### Bonus exercise
<mark>How might you handle the case when someone specifies a time in the past?</mark>

## Documentation and help

Now that we have a usable script, we need to address the other reusability requirement: that the script give us some help as to how to use it.

### Comment-based help

Powershell allows for comment-based help, which are comments within the script that are displayed by the get-help cmdlet.

With our current script, we go get some information using get-help:

```powershell
c:\> get-help .\reboot-at.ps1
reboot-at.ps1 [[-computerName] <string>] [-RestartTime] <datetime> [<CommonParameters>]
```

This does tell us that it wants two parameters, and that the computername parameter is optional (as evidenced by its being in square brackets).  Happily, we can do better, still.

#### Help Template

Comment-based help uses the following comment block at the beginning of a script or function.

```powershell
<#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER <ParameterName>
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
        FunctionName : 
        Version: 
        Created by   : 
        Date Coded   : 
    .LINK
        Home
 #>
```

The notes section can, in fact, be pretty much any text.  Multiple links and multiple examples can be included as additional .EXAMPLE and .LINK entries.

We might use something like the following for our reboot-at script.

```powershell
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
$rebootParams=@(
"/t $($WaitSeconds)"
"/r"
)
if ($PSBoundParameters.ContainsKey("computerName")) 
{
    $rebootParams.Add("/m \\$($computerName)")
}
start-process shutdown -arg $rebootParams
```

With this in place, we can run get-help against our script:

```powershell
PS C:\> get-help .\reboot-at.ps1

NAME
    C:\reboot-at.ps1
    
SYNOPSIS
    Reboots a computer at a specified date and time
    
    
SYNTAX
    C:\reboot-at.ps1 [[-computerName] <String>] 
    [-RestartTime] <DateTime> [<CommonParameters>]
    
    
DESCRIPTION
    uses the Windows shutdown.exe application with the /t timer switch to reboot a computer at a specified date and 
    time.
    

RELATED LINKS
    https://wiki.smu.edu/display/ITS/Powershell+Cmdlets+and+Scripts

REMARKS
    To see the examples, type: "Get-Help c:\reboot-at.ps1 
    -Examples"
    For more information, type: "Get-Help c:\reboot-at.ps1 
    -Detailed"
    For technical information, type: "Get-Help 
    c:\reboot-at.ps1 -Full"
    For online help, type: "Get-Help c:\reboot-at.ps1 
-Online"
```

As you can see, there are some details we specified in our comments that aren't displayed.  The remarks tell us we can use the <mark>-Examples</mark>, <mark>-Detailed</mark>, and <mark>-Full</mark> switches to get more help.
