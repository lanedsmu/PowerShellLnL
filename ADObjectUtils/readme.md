# Active Directory object viewing with PowerShell

- [View accounts and groups](#accounts-and-groups)
- [View account properties](#account-properties)
- [List Group members](#list-group-members)
- [Select specific properties](#select-function)

Cmdlets like get-aduser and get-adgroup rely on the ActiveDirectory PowerShell module.  This needs to be installed or enabled on your (<mark>Windows-only</mark>; sorry) workstation before they'll be available:
<https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2019-ps>

- Get-AdUser
- Get-AdGroup
- Get-AdGroupMember

Are all very powerful cmdlets, and each will let you see things like whether an account is locked out, or who what a user's group membership looks like.

Note that the ability to enumerate AD group membership is a privilege that isn't available to most regular SMU accounts.

## Accounts and groups

### Searching for accounts and groups

To find a SMU ID based on a user's name, use the <mark>-filter</mark> parameter and a "<mark>*</mark>" for wildcard searching.  

```powershell
get-aduser -filter "(displayname -like 'duncan*')"

get-adgroup -filter "(name -like 'OIT*')"
```

### Account properties

To look up account details like whether the account is locked out or password expired, use the following:

```powershell
import-module activedirectory
Get-ADUser -identity xxxxxxx -properties DisplayName, LastBadPasswordAttempt, LastLogonDate, LockedOut, AccountExpirationDate, PasswordExpired, BadLogonCount, badPwdCount, lockoutTime
```

To see all of the properties available, use a wildcard for the properties parameter and pipe it to get-member:

```powershell
PS C:\> get-aduser -properties * -identity xxxxxxx |get-member

   TypeName: Deserialized.Microsoft.ActiveDirectory.Management.ADUser

Name                                 MemberType   Definition
----                                 ----------   ----------
GetType                              Method       type GetType()
ToString                             Method       string ToString(), string To.
PSComputerName                       NoteProperty string PSComputerName=localh.
PSShowComputerName                   NoteProperty bool PSShowComputerName=False
RunspaceId                           NoteProperty guid RunspaceId=152ccd92-eb7.
AccountExpirationDate                Property      {get;set;}
accountExpires                       Property     System.Int64 {get;set;}
AccountLockoutTime                   Property      {get;set;}
AccountNotDelegated                  Property     System.Boolean {get;set;}
AllowReversiblePasswordEncryption    Property     System.Boolean {get;set;}
AuthenticationPolicy                 Property     Deserialized.Microsoft.Activ.
AuthenticationPolicySilo             Property     Deserialized.Microsoft.Activ.
BadLogonCount                        Property     System.Int32 {get;set;}
badPasswordTime                      Property     System.Int64 {get;set;}
badPwdCount                          Property     System.Int32 {get;set;}
CannotChangePassword                 Property     System.Boolean {get;set;}
CanonicalName                        Property     System.String {get;set;}
Certificates                         Property     Deserialized.Microsoft.Activ.
City                                 Property      {get;set;}
CN                                   Property     System.String {get;set;}
codePage                             Property     System.Int32 {get;set;}
Company                              Property      {get;set;}
CompoundIdentitySupported            Property     Deserialized.Microsoft.Activ.
Country                              Property      {get;set;}
countryCode                          Property     System.Int32 {get;set;}
Created                              Property     System.DateTime {get;set;}
createTimeStamp                      Property     System.DateTime {get;set;}
Deleted                              Property      {get;set;}
delivContLength                      Property     System.Int32 {get;set;}
Department                           Property     System.String {get;set;}
Description                          Property     System.String {get;set;}
directReports                        Property     Deserialized.Microsoft.Activ.
DisplayName                          Property     System.String {get;set;}
DistinguishedName                    Property     System.String {get;set;}
Division                             Property     System.String {get;set;}
DoesNotRequirePreAuth                Property     System.Boolean {get;set;}
dSCorePropagationData                Property     Deserialized.Microsoft.Activ.
eduPersonAffiliation                 Property     Deserialized.Microsoft.Activ.
eduPersonEntitlement                 Property     Deserialized.Microsoft.Activ.
eduPersonPrimaryAffiliation          Property     System.String {get;set;}
EmailAddress                         Property     System.String {get;set;}
EmployeeID                           Property      {get;set;}
EmployeeNumber                       Property      {get;set;}
employeeType                         Property     System.String {get;set;}
Enabled                              Property     System.Boolean {get;set;}
extensionAttribute1                  Property     System.String {get;set;}
Fax                                  Property      {get;set;}
GivenName                            Property     System.String {get;set;}
HomeDirectory                        Property     System.String {get;set;}
HomedirRequired                      Property     System.Boolean {get;set;}
HomeDrive                            Property     System.String {get;set;}
homeMDB                              Property     System.String {get;set;}
HomePage                             Property      {get;set;}
HomePhone                            Property      {get;set;}
Initials                             Property     System.String {get;set;}
instanceType                         Property     System.Int32 {get;set;}
isDeleted                            Property      {get;set;}
KerberosEncryptionType               Property     Deserialized.Microsoft.Activ.
LastBadPasswordAttempt               Property     System.DateTime {get;set;}
LastKnownParent                      Property      {get;set;}
lastLogoff                           Property     System.Int64 {get;set;}
lastLogon                            Property     System.Int64 {get;set;}
LastLogonDate                        Property     System.DateTime {get;set;}
lastLogonTimestamp                   Property     System.Int64 {get;set;}
legacyExchangeDN                     Property     System.String {get;set;}
LockedOut                            Property     System.Boolean {get;set;}
lockoutTime                          Property     System.Int64 {get;set;}
logonCount                           Property     System.Int32 {get;set;}
LogonWorkstations                    Property      {get;set;}
mail                                 Property     System.String {get;set;}
mailNickname                         Property     System.String {get;set;}
managedObjects                       Property     Deserialized.Microsoft.Activ.
Manager                              Property     System.String {get;set;}
mDBOverHardQuotaLimit                Property     System.Int32 {get;set;}
mDBOverQuotaLimit                    Property     System.Int32 {get;set;}
mDBStorageQuota                      Property     System.Int32 {get;set;}
mDBUseDefaults                       Property     System.Boolean {get;set;}
MemberOf                             Property     Deserialized.Microsoft.Activ.
MNSLogonAccount                      Property     System.Boolean {get;set;}
MobilePhone                          Property      {get;set;}
Modified                             Property     System.DateTime {get;set;}
modifyTimeStamp                      Property     System.DateTime {get;set;}
mS-DS-ConsistencyGuid                Property     System.Byte[] {get;set;}
msDS-ExternalDirectoryObjectId       Property     System.String {get;set;}
msDS-KeyCredentialLink               Property     Deserialized.Microsoft.Activ.
msDS-User-Account-Control-Computed   Property     System.Int32 {get;set;}
msExchAuditOwner                     Property     System.Int32 {get;set;}
msExchBlockedSendersHash             Property     System.Byte[] {get;set;}
msExchCoManagedObjectsBL             Property     Deserialized.Microsoft.Activ.
msExchELCMailboxFlags                Property     System.Int32 {get;set;}
msExchHomeServerName                 Property     System.String {get;set;}
msExchMailboxAuditEnable             Property     System.Boolean {get;set;}
msExchMailboxAuditLastAdminAccess    Property     System.DateTime {get;set;}
msExchMailboxGuid                    Property     System.Byte[] {get;set;}
msExchMailboxSecurityDescriptor      Property     System.String {get;set;}
msExchMailboxTemplateLink            Property     System.String {get;set;}
msExchMobileMailboxFlags             Property     System.Int32 {get;set;}
msExchMobileMailboxPolicyLink        Property     System.String {get;set;}
msExchPoliciesExcluded               Property     Deserialized.Microsoft.Activ.
msExchProvisioningFlags              Property     System.Int32 {get;set;}
msExchRBACPolicyLink                 Property     System.String {get;set;}
msExchRecipientDisplayType           Property     System.Int32 {get;set;}
msExchRecipientTypeDetails           Property     System.Int64 {get;set;}
msExchSafeSendersHash                Property     System.Byte[] {get;set;}
msExchShadowProxyAddresses           Property     Deserialized.Microsoft.Activ.
msExchTextMessagingState             Property     Deserialized.Microsoft.Activ.
msExchUMDtmfMap                      Property     Deserialized.Microsoft.Activ.
msExchUMEnabledFlags                 Property     System.Int32 {get;set;}
msExchUMPinChecksum                  Property     System.Byte[] {get;set;}
msExchUMRecipientDialPlanLink        Property     System.String {get;set;}
msExchUMSpokenName                   Property     System.Byte[] {get;set;}
msExchUMTemplateLink                 Property     System.String {get;set;}
msExchUserAccountControl             Property     System.Int32 {get;set;}
msExchUserCulture                    Property     System.String {get;set;}
msExchVersion                        Property     System.Int64 {get;set;}
msExchWhenMailboxCreated             Property     System.DateTime {get;set;}
msRTCSIP-DeploymentLocator           Property     System.String {get;set;}
msRTCSIP-FederationEnabled           Property     System.Boolean {get;set;}
msRTCSIP-InternetAccessEnabled       Property     System.Boolean {get;set;}
msRTCSIP-Line                        Property     System.String {get;set;}
msRTCSIP-OptionFlags                 Property     System.Int32 {get;set;}
msRTCSIP-PrimaryHomeServer           Property     System.String {get;set;}
msRTCSIP-PrimaryUserAddress          Property     System.String {get;set;}
msRTCSIP-UserEnabled                 Property     System.Boolean {get;set;}
msRTCSIP-UserPolicies                Property     Deserialized.Microsoft.Activ.
msRTCSIP-UserRoutingGroupId          Property     System.Byte[] {get;set;}
msTSExpireDate                       Property     System.DateTime {get;set;}
msTSLicenseVersion                   Property     System.String {get;set;}
msTSLicenseVersion2                  Property     System.String {get;set;}
msTSLicenseVersion3                  Property     System.String {get;set;}
msTSManagingLS                       Property     System.String {get;set;}
Name                                 Property     System.String {get;set;}
nTSecurityDescriptor                 Property     System.String {get;set;}
o                                    Property     Deserialized.Microsoft.Activ.
ObjectCategory                       Property     System.String {get;set;}
ObjectClass                          Property     System.String {get;set;}
ObjectGUID                           Property     System.Guid {get;set;}
objectSid                            Property     System.String {get;set;}
Office                               Property      {get;set;}
OfficePhone                          Property     System.String {get;set;}
Organization                         Property     System.String {get;set;}
OtherName                            Property      {get;set;}
PasswordExpired                      Property     System.Boolean {get;set;}
PasswordLastSet                      Property     System.DateTime {get;set;}
PasswordNeverExpires                 Property     System.Boolean {get;set;}
PasswordNotRequired                  Property     System.Boolean {get;set;}
POBox                                Property      {get;set;}
PostalCode                           Property      {get;set;}
PrimaryGroup                         Property     System.String {get;set;}
primaryGroupID                       Property     System.Int32 {get;set;}
PrincipalsAllowedToDelegateToAccount Property     Deserialized.Microsoft.Activ.
ProfilePath                          Property      {get;set;}
ProtectedFromAccidentalDeletion      Property     System.Boolean {get;set;}
proxyAddresses                       Property     Deserialized.Microsoft.Activ.
pwdLastSet                           Property     System.Int64 {get;set;}
SamAccountName                       Property     System.String {get;set;}
sAMAccountType                       Property     System.Int32 {get;set;}
ScriptPath                           Property     System.String {get;set;}
sDRightsEffective                    Property     System.Int32 {get;set;}
ServicePrincipalNames                Property     Deserialized.Microsoft.Activ.
showInAddressBook                    Property     Deserialized.Microsoft.Activ.
SID                                  Property     System.String {get;set;}
SIDHistory                           Property     Deserialized.Microsoft.Activ.
SmartcardLogonRequired               Property     System.Boolean {get;set;}
sn                                   Property     System.String {get;set;}
State                                Property      {get;set;}
StreetAddress                        Property      {get;set;}
submissionContLength                 Property     System.Int32 {get;set;}
Surname                              Property     System.String {get;set;}
telephoneNumber                      Property     System.String {get;set;}
thumbnailPhoto                       Property     System.Byte[] {get;set;}
Title                                Property      {get;set;}
TrustedForDelegation                 Property     System.Boolean {get;set;}
TrustedToAuthForDelegation           Property     System.Boolean {get;set;}
UseDESKeyOnly                        Property     System.Boolean {get;set;}
userAccountControl                   Property     System.Int32 {get;set;}
userCertificate                      Property     Deserialized.Microsoft.Activ.
UserPrincipalName                    Property     System.String {get;set;}
uSNChanged                           Property     System.Int64 {get;set;}
uSNCreated                           Property     System.Int64 {get;set;}
whenChanged                          Property     System.DateTime {get;set;}
whenCreated                          Property     System.DateTime {get;set;}
```

### List group members

The get-adgroupmember cmdlet will show all members of a particular AD group.  Note that most domain accounts don't have the ability to enumerate domain groups.

```powershell
get-adgroupmember "OIT All"
```

### Select function

To see only the names of the group members, instead of all of the default properties, use the <mark>select</mark> (alias for select-object) function:

```powershell
get-adgroupmember "OIT All" | select name
```

The select function can be coupled with many cmdlets to filter the display to give just the information you are looking for.

Try using <mark>select</mark> coupled with the get-aduser function to see only specific properties, like lockedout and PasswordExpired
