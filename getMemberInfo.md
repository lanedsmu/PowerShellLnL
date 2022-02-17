# Get-member and get-help

Bottom line on top:  
Get-member is your friend.  It'll tell you a fair bit about cmdlets you might want to use.  
Don't ignore get-help, as that includes some information that get-member does not.

## get-member usage

get-member takes an object (in this case, a cmdlet, but it can be any object) and returns its components.

```powershell
get-uptime |get-member
```

```powershell
 PS C:\git\PowerShellLnL> get-uptime |get-member
 
    TypeName: System.TimeSpan
 
 Name              MemberType Definition
 ----              ---------- ----------
 Add               Method     timespan Add(timespan ts)
 CompareTo         Method     int CompareTo(System.Objectvalue), int CompareTo(timespan value), int    IComparable.Compare…
 Divide            Method     timespan Divide(doubledivisor), double Divide(timespan ts)
 Duration          Method     timespan Duration()
 Equals            Method     bool Equals(System.Objectvalue), bool Equals(timespan obj), bool     IEquatabl[timespan].Equ…
 GetHashCode       Method     int GetHashCode()
 GetType           Method     type GetType()
 Multiply          Method     timespan Multiply(doublefactor)
 Negate            Method     timespan Negate()
 Subtract          Method     timespan Subtract(timespants)
 ToString          Method     string ToString(), stringToString(string format), string ToString    (stringformat, System.I…
 TryFormat         Method     bool TryFormat(System.Spa[char] destination, [ref] int charsWritten,     SystemReadOnlySpan[…
 Days              Property   int Days {get;}
 Hours             Property   int Hours {get;}
 Milliseconds      Property   int Milliseconds {get;}
 Minutes           Property   int Minutes {get;}
 Seconds           Property   int Seconds {get;}
 Ticks             Property   long Ticks {get;}
 TotalDays         Property   double TotalDays {get;}
 TotalHours        Property   double TotalHours {get;}
 TotalMilliseconds Property   double TotalMilliseconds{get;}
 TotalMinutes      Property   double TotalMinutes {get;}
 TotalSeconds      Property   double TotalSeconds {get;}
```

Notice there are "methods" and "properties" listed here.  
Now we know we can do something like this:

```powershell
(get-uptime).TotalDays
```

```text
PS C:\git\PowerShellLnL> (get-uptime).totaldays

1.57912037037037
```

Parenthesis are important in the above command: if we omit them, PowerShell can't tell we're wanting to reference a property of an object or if that's part of the command.

But maybe there's more we can do.  Let's see what the built-in help tells us.

```powershell
get-help get-uptime
```

```text
PS C:\git\PowerShellLnL> get-help get-uptime

NAME
    Get-Uptime

SYNOPSIS
    Get the TimeSpan since last boot.

SYNTAX
    Get-Uptime [-Since] [<CommonParameters>]

DESCRIPTION
    This cmdlet returns the time elapsed since the last boot of the operating system.

    The `Get-Uptime` cmdlet was introduced in PowerShell 6.0.
<...>
```

So now we see:

- get-uptime was introduced in Powershell 6 (so if you're running an earlier version, as most of our servers are, it's not available)
- there's a -since parameter that doesn't show up in get-member (parameters aren't object members, is why)

Check out the -since parameter:

```powershell
PS C:\git\PowerShellLnL> get-uptime -since


Thursday, February 10, 2022 6:24:30 PM
```
