#requires -module Az.Resources
BeforeAll {
    Import-Module $PSScriptRoot/../AzResourcesExtensions.psd1 -Force
}
Describe 'Add-AZADAppRoleAssignment' {
    It 'Simple Assignment' {
        $appRole = Get-AzADServicePrincipal -DisplayName 'office 365 exchange online'

        $sp | Get-AzAdAppRole
    }
}
