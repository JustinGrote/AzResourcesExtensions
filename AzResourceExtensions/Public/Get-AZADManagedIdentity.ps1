#requires -version 7
#because of invokerestmethod -rellink use
using namespace System.Management.Automation
using namespace System.Threading.Tasks

function Get-AzADManagedIdentity {
    <#
    .SYNOPSIS
    Get the app role for a specified service
    #>
    param (
        #The object ID of the service principal you wish to retrieve the role. Fetchable from Get-AzAdServicePrincipal
        [Parameter(ValueFromPipelineByPropertyName)]
        [Guid]$Id
    )
    
    process {
        $path = 'servicePrincipals'
        if ($id) {
            $path = $path,$id -join '/'
        }
        $graphParams = @{
            Path = $path
            Body = @{}
        }

        if ($id -eq [guid]::Empty) {
            $Body.'$filter' = "servicePrincipalType eq 'ManagedIdentity'"
        }
        
        Invoke-AzADGraphMethod @graphParams
    }

    #Region NetMethod
    #Preserved for Example
    # #Extract a service principals client from this cmdlet
    # $spClient = [GetAzureAdServicePrincipalCommand]::new().ActiveDirectoryClient.graphclient.serviceprincipals
    
    # #Now we will fetch the principal
    # #TODO: Odata query expanding to only the approle property for efficiency
    # $servicePrincipal = await $spClient.GetWithHttpMessagesAsync($Id)

    # #Extract the approles from the principal
    # ($serviceprincipal.Body)[0].AdditionalProperties['appRoles'].ToObject([AppRole[]]) | Foreach {
    #     $PSItem.AppId = $Id
    #     $PSItem
    # }
    #endregion NETMethod
}