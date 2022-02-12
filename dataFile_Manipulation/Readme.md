# CSV and JSON handling in PowerShell

```powershell
get-content ./sampleDataFiles/sample4.csv | convertfrom-csv |Where-Object "game
length" -eq 29


$settings = get-content ./sampleDataFiles/myJsonSettingsFile.json | convertfrom-json
$settings.myComputername

# we'll loop through each doesn't have 'noreply' in it
foreach ($email in ($settings.myEmailAddresses |where {$_ -notLike "noReply*"}))
    {
        send-mailmessage -body "test for me!" -subject "here's my subject" -to @email -from "noreply@smu.edu" -smtpServer relay.smu.edu
    }
```

You can convert to and from json and csv, too.  Though note this wrinkle: arrays don't automatically get flattened in that conversion:

```powershell
PS C:\git\PowerShellLnL> $settings |convertto-csv
"myComputerName","myFavoriteNumbers","myEmailAddresses"
"localhost","System.Object[]","System.Object[]"
```

Cool json flattening function written can be found here:
<https://stackoverflow.com/questions/45829754/convert-nested-json-array-into-separate-columns-in-csv-file>
