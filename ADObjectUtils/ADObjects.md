# Active Directory object management with PowerShell

Cmdlets like get-aduser and get-adgroup rely on the ActiveDirectory PowerShell module.  This needs to be installed or enabled on your (Windows-only; sorry) workstation before they'll be available:
<https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2019-ps>

- Get-AdUser
- Get-AdGroup
- Get-AdGroupMember

Are all very powerful cmdlets, and each will let you see things like whether an account is locked out, or who what a user's group membership looks like.

Note that the ability to enumerate AD group membership is a privilege that isn't available to most regular SMU accounts.
