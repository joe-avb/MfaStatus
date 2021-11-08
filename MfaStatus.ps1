Import-Module MSOnline -UseWindowsPowerShell
Connect-MsolService
Get-MsolUser -all |
    Select-Object DisplayName,UserPrincipalName,isLicensed,@{N="MFA Status"; E={
        if($_.StrongAuthenticationRequirements.Count -ne 0){
            $_.StrongAuthenticationRequirements[0].State
        } else {
            'Disabled'}
        }
    } |
    Where-Object {$_.IsLicensed -ne $False -and `
                  $_.UserPrincipalName -notlike "*#EXT#*"} |
    Sort-Object -Property UserPrincipalName |
Export-CSV "Path\To\MfaDisabledUserReport_$(Get-Date -f yyyy-MM-dd-hhmm).csv"