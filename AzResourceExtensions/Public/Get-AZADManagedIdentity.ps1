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

    # function await ([Task]$Task) {
    #     #Simple helper function for async methods
    #     $Task.GetAwaiter().GetResult()
    # }

    #Region NetMethod
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

    #Powershell Method
    $graphToken = Get-AzAccessToken -ResourceTypeName AadGraph
    $BaseUri = 'https://graph.windows.net',[Guid]$graphToken.TenantId -join '/'
    if ($Id) {
        $requestPath = 'servicePrincipals',$Id -join '/'
    } else {
        $requestPath = 'servicePrincipals'
    }
    
    $irmParams = @{
        URI = $($baseUri,$requestPath -join '/')
        Body = @{
            'api-version' = 1.6
            '$filter' = "servicePrincipalType eq 'ManagedIdentity'"
        }
        Authentication = 'Bearer'
        Token = $graphToken.Token | ConvertTo-SecureString -AsPlainText -Force
        FollowRelLink = $true
    }
    $result = Invoke-RestMethod @irmParams
    $result.value | Select-Object ServicePrincipalNames,
        objectType,
        DisplayName,
        @{N='Id';E={$PSItem.ObjectId}},
        @{N='ApplicationId';E={$PSItem.AppId}},
        @{N='Type';E={$PSItem.servicePrincipalType}} | foreach {
            [Microsoft.Azure.Commands.ActiveDirectory.PSADServicePrincipal]$PSItem
        }
}