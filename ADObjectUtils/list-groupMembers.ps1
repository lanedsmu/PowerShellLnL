get-adgroup -identity xxxx

get-adgroupmember -identity "OIT All"

$adGroups = get-adgroup -filter { Name -eq "OIT All" }
$members = (get-adgroup $adGroups -properties members).members
$memberproperties = $members |get-aduser -properties displayname
