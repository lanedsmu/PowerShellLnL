<#
.SYNOPSIS
Exports XLSX sheets to CSV files

.DESCRIPTION
Uses Excel (must be installed on the workstation) to export CSV files, one per sheet, from Excel files.
Save path is the location of the xlsx file, and destination filename is 
<xlsxfilename>_<sheetName>.csv

.PARAMETER FilePath
Path to the .xlsx file.  Relative paths are OK.  This will also be the destination used for the csv output files.

.EXAMPLE
convertFrom-excel2csv -FilePath .\resunits.xlsx
Will export CSV file(s) from the sheet(s) in ./resunits.xlsx.  Output CSV path will be the same (./)

.NOTES
Version: 1.00.00
Author: Lane Duncan

CHANGELOG
    v1.00.00    20220218    Lane Duncan
        Initial release

H/T to https://github.com/guimatheus92/Convert-Excel-file-to-CSV-from-a-PowerShell-script

#>
Function convertFrom-excel2csv {
    param(
        [string]$FilePath
        ) 
    # here we use resolve-path to get the abosolute file path, in case relative pathing was used.
    $fullPath=resolve-path -LiteralPath $FilePath
    $File = split-path -path $FilePath -LeafBase
    $savePath = (split-path -path $fullPath -Parent)+"\"

    $E = New-Object -ComObject Excel.Application
    $E.Visible = $false
    $E.DisplayAlerts = $false
    $wb = $E.Workbooks.Open($fullPath)
    foreach ($ws in $wb.Worksheets) {
        # when we save, we use <filename>_<worksheetName>.csv as our template
        # we save back to the same 
        $n = "$($File)_$($ws.name)"
        $ws.SaveAs($savePath + $n + ".csv", 6)
    }
    $E.Quit()
}

