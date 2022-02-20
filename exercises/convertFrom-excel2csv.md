# Exporting Excel sheets to CSV files

A quick google search shows that converting Excel sheets to CSV files is a common problem, and there are a lot of ways to solve it.  PowerShell (coupled with Excel) has a pretty straightforward approach, like what is laid out here:

<https://github.com/guimatheus92/Convert-Excel-file-to-CSV-from-a-PowerShell-script>

## ImportExcel Module

A function based on that can be found [here](./convertFrom-excel2csv.ps1).  There's another method that doesn't require Excel, using the importexcel module published in the PowerShell gallery.

See <https://devblogs.microsoft.com/scripting/introducing-the-powershell-excel-module-2/> for details.

```powershell
install-module importexcel
```

Using the import-excel function we can export a worksheet to csv using just .net commands:

```powershell
Import-Excel -WorksheetName Master -path ./resunits.xlsx |export-csv -Path ./resunits.csv
```

This is cross-platform function without relying on Excel, to boot.  Give it a shot!

Import-Excel gives you the ability to import worksheet data into variables and work on that data in a script.
