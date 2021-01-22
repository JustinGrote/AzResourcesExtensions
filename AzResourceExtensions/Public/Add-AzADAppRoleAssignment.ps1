function Add-AzADAppRoleAssignment {
    <#
    .SYNOPSIS
    Get the app role for a specified service
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        #The ID of the app role you wish to assign. Can be piped in from a Get-AzADAppRole result
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias('AppRoleId')]
        [Guid]$Id,

        #The ID of the application that owns the app role you wish to assign. Can be piped in from a Get-AzADAppRole result
        #TODO: Autodetect based on appId by searching for it
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Guid]$resourceId,

        #The ID of the target identity that will be granted the role
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Guid]$PrincipalId
    )
    
    process {
        $graphParams = @{
            Path   = "servicePrincipals/$PrincipalId/appRoleAssignments"
            Method = 'POST'
            Body   = @{
                principalId = $PrincipalId
                resourceId  = $ResourceId
                appRoleId   = $Id
            }
        }
        
        Invoke-AzADGraphMethod @graphParams
    }
}