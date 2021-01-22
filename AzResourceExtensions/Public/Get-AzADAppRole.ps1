class AppRole {
    [string]$Description
    [string]$DisplayName
    [guid]$Id
    [bool]$IsEnabled
    [string[]]$AllowedMemberTypes
    [string]$Value
    [string]$origin
    [guid]$ResourceId

    [string]ToString() {
        return $this.Id
    }
}


function Get-AzADAppRole {
    <#
    .SYNOPSIS
    Get the app role for a specified service
    #>
    param (
        #The object ID of the service principal you wish to retrieve the role. Fetchable from Get-AzAdServicePrincipal
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Guid]$Id
    )

    #Powershell Method

    process {
        $graphParams = @{
            Path = 'servicePrincipals',$Id,'appRoles' -join '/'
        }
        Invoke-AzADGraphMethod @graphParams | Foreach-Object {
            $result = [AppRole]$PSItem
            $result.ResourceId = $Id
            $result
        }
    }

    #Region NetMethod
    # Preserved for reference
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