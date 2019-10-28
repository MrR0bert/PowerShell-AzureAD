$allUsers = Get-AzureADUser -All $True
$userDetails = @()

$allUSers | % {
    Write-Output "Processing user $($_.userPrincipalName)"
    $userGroups = Get-AzureADUserMembership -ObjectId $_.ObjectId
    $userLicenseDetails = Get-AzureADUserLicenseDetail -ObjectId $_.ObjectId

    $userDetails += [PSCustomObject]@{
        userPrincipalName = $_.userPrincipalName
        licenseCount = $userLicenseDetails.count
        memberOfOffice365ADGroup = (($userGroups -match "Office 365 Enterprise E3").count -gt 0)
        hasOffice365E3 = (($userLicenseDetails -match "ENTERPRISEPACK").count -gt 0)
        hasOffice365E5 = (($userLicenseDetails -match "ENTERPRISEPREMIUM").count -gt 0)
    }
}

$userDetails | Export-CSV C:\temp\overview.csv -Force
$userDetails | ft