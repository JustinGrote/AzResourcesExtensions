#requires -module AzureAD
<#
.LINK
https://stackoverflow.com/questions/63953702/access-o365-exchange-online-with-an-azure-managed-identity-or-service-principal
https://finarne.wordpress.com/2019/03/17/azure-function-using-a-managed-identity-to-call-sharepoint-online/
#>

function New-AzManagedIdentityRoleAssignment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #Object ID of the managed service identity you wish to use
        [Parameter(ValueFromPipelineByPropertyName)][Guid]$ObjectId,

        #The Object Id of the application that holds the role you want to assign
        [Guid]$RefObjectId,

        #The Role that you wish to 
        [Guid]$RoleId,

        #Specify that you want to use Interactive Mode
        [Switch]$Interactive,

        #Choose an Interactive mode. Will use Out-Gridview by default and fallback to console if not available
        [ValidateSet('GUI','Console')]$InteractiveMode = 'GUI'
    )

    $ErrorActionPreference = 'Stop'

    #Interactive Mode Sanity Check

    if ($Interactive) {
        if ($InteractiveMode -eq 'GUI' -and -not (Get-Command 'Out-GridView' -ErrorAction SilentlyContinue)) {
            if ($PSVersionTable.PSVersion -ge '6.2.0' -and (Get-Command 'Out-ConsoleGridView' -ErrorAction SilentlyContinue)) {
                $InteractiveMode = 'Console'
            } else {
                throw [NotSupportedException]'-Interactive was specified but neither Out-Gridview or Out-ConsoleGridview was found. Hint: Install-Module Microsoft.Powershell.ConsoleGuiTools'
            }
        }

        $InteractiveCommand = switch ($InteractiveMode) {
            'GUI' {
                'Out-GridView'
            }
            'Console' {
                'Out-ConsoleGridView'
            }
        }
    }

    if (-not $ObjectId) {
        if ($Interactive) {
            $targetSP = Get-AzureADServicePrincipal -filter "servicePrincipalType eq 'ManagedIdentity'" -Top ([int]::MaxValue) |
                & $InteractiveCommand -Title 'Select the target Service Principal for role assignment' -OutputMode Single
            $objectId = $targetSP.ObjectId
        }
    }
    if (-not $ObjectId) {throw 'You must select a service principal to which the new roles will be assigned'}

    if (-not $RefObjectId) {
        if ($Interactive) {
            $RefSP = Get-AzureADServicePrincipal -All:$true | 
            Where-Object approles | 
            Sort-Object DisplayName |
            & $InteractiveCommand -Title 'Select the app that has the role you wish to assign' -OutputMode Single
            $RefObjectId = $RefSP.ObjectId
        }
    }
    if (-not $RefObjectId) {throw [InvalidOperationException]'You must select a service principal to which the new roles will be assigned'}

    if (-not $RoleId) {
        if ($Interactive) {
            $RoleItem = $RefSP.approles | 
            Where-Object AllowedMemberTypes | 
            Select-Object Id,@{N='AppName';E={$RefSP.DisplayName}},DisplayName,Description,Value,IsEnabled |
            Sort-Object DisplayName |
            & $InteractiveCommand -Title 'Select the role to assign to the app' -OutputMode Single
            $RoleId = $RoleItem.Id
        }
    }
    if (-not $RoleId) {throw [InvalidOperationException]'You must select a service principal to which the new roles will be assigned'}

    if ($PSCmdlet.ShouldProcess($ObjectId,"Add Application Role")) {
        New-AzureAdServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId -ResourceId $RefObjectId -Id $RoleId
    } else {
        New-AzureAdServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId -ResourceId $RefObjectId -Id $RoleId -WhatIf
    }
}