function GetShareNames ($ip){
    Write-Host "[***] Getting share information for $ip"
    $ShareNames = (net view \\$ip) | % { if($_.IndexOf(' Disk ') -gt 0){ $_.Split('  ')[0] } }
    Write-Host "[***] A total of "$ShareNames.count "folders have been found"
    Write-Host "[***] Preparing to test permissions on all folders"
    $status = 0
        foreach ($share in $ShareNames){
        Write-Progress -Activity "Testing permissions" -Status "Progress:" -PercentComplete ($i/$ShareNames.count*100)
        icacls.exe "\\$ip\$share" 2>$testing2 | Where {$_ -ne 'Successfully processed 0 files; Failed processing 1 files'}
        $i = $i+1
    }
    return
}
if ($Args[0] -eq "-t"){
    $ip = $Args[1]
    GetShareNames($ip)
}
elseif ($Args[0] -eq "-f"){
    $ips = Get-Content -Path $Args[1]
    foreach ($ip in $ips){
        GetShareNames($ip)
    }
}
else {
    Write-Host "Available commands are:`n./smbmap.ps1 -t target`n./smbmap.ps1 -f targetfile "
    }
