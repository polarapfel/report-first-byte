param (
    [Parameter(Mandatory=$true)][string]$uri,
    [Parameter(Mandatory=$true)][Int32]$requests,
    [Parameter(Mandatory=$true)][string]$label,
    [Parameter(Mandatory=$true)][Int32]$wsleep
 )

$reportpath = "$($PWD){0}$($label)-report.csv" -f [IO.Path]::DirectorySeparatorChar
$tmppath = "$($PWD){0}tmp" -f [IO.Path]::DirectorySeparatorChar
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$csvheader = "$($scriptdir){0}report-header-csv.txt" -f [IO.Path]::DirectorySeparatorChar
$csvformat = "$($scriptdir){0}curl-format-csv.txt" -f [IO.Path]::DirectorySeparatorChar

Write-Host "Writing report to $($reportpath)"

New-Item -Path $reportpath -ItemType File

Add-Content $reportpath "$($label)`nUri: $($uri)`n"

$From = Get-Content -Path $csvheader
Add-Content -Path $reportpath -Value $From

for ($num = 1 ; $num -le $requests ; $num++)
{
    curl -w "@$($csvformat)" -r 0-1 -s $uri -o $tmppath >> $reportpath
    Start-Sleep -s $wsleep
}

Remove-Item -Path $tmppath
