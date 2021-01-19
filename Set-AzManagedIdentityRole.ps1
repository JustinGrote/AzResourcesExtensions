function Add-AzManagedIdentityPermission {
    param(
        [String]$ObjectId
    )

    $ErrorActionPreference = 'Stop'
    $sp = Get-AzureADServicePrincipal -Filter  "displayName eq 'Office 365 Exchange Online'"

}