<#
.LINK
https://stackoverflow.com/questions/63953702/access-o365-exchange-online-with-an-azure-managed-identity-or-service-principal
https://finarne.wordpress.com/2019/03/17/azure-function-using-a-managed-identity-to-call-sharepoint-online/
#>

function Add-AzManagedIdentityAppRole {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #Object ID of the managed service identity you wish to use
        [Parameter(ValueFromPipelineByPropertyName)][String]$ObjectId,

        #Specify that you want to use Interactive Mode
        [Switch]$Interactive
    )

    $ErrorActionPreference = 'Stop'
    $sp = Get-AzureADServicePrincipal -Filter  "displayName eq 'Office 365 Exchange Online'"

    if (-not $ObjectId -and -not $Interactive) {

    }

}