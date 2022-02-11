param(
    [parameter(mandatory)]
    [int]$days,
    [parameter(mandatory)]
    [string]$path,
    [string]$filter,
    [switch]$recurse
)
if ($PSBoundParameters.ContainsKey($filter))
{
    [string]$gciParam="-include $($filter)"
}
if ($recurse) {
    $gciParam+=" -recurse"
}
Get-ChildItem -Path $path $gciParam |Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-$days) }| Sort-Object CreationTime