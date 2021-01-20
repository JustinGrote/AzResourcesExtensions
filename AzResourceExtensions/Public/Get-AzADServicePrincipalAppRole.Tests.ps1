#requires -module Az.Resources
Describe 'Get-AZADServicePrincipalAppRole' {
    BeforeAll {
        . $PSScriptRoot/Get-AZADServicePrincipalAppRole.ps1
    }
    It "Accepts service principal via pipeline" {
        Get-AzADServicePrincipal -DisplayName 'office 365 exchange online' | 
            Get-AzAdServicePrincipalAppRole -OutVariable result |
            Should -Not -BeNullOrEmpty
        $result[0].getType().Name | Should -Be 'AppRole'
        $result[0].value | Should -Contain 'Exchange.ManageAsApp'
        $result[0].id | Should -BeOfType ([Guid])
    }

    It "Fails to find fake guid" {
        {Get-AzAdServicePrincipalAppRole -Id 'ffffffff-ffff-ffff-ffff-ffffffffffff'} |
            Should -Throw '*NotFound*'
    }
}
