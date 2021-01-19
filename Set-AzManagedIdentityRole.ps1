#requires -module AzureAD
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
        [Switch]$Interactive,

        #Choose an Interactive mode. Will use Out-Gridview by default
        [ValidateSet('GUI','Console')]$InteractiveMode
    )

    $ErrorActionPreference = 'Stop'
    $selectionMethod = if (get-command Out-Gridview)

    if (-not $ObjectId) {
        if (-not $Interactive) {
            throw [InvalidOperationException]'You must provide a service identity to act upon, either by its objectID, via the pipeline, or via the -Interactive switch'
        }

    }


}