#requires -module Az.Resources
BeforeAll {
    Import-Module $PSScriptRoot/../AzResourcesExtensions.psd1 -Force
}
Describe 'Get-AZADServicePrincipalAppRole' {
    It 'Service principal via pipeline' {
        $sp = Get-AzADServicePrincipal -DisplayName 'office 365 exchange online'

        $sp | Get-AzAdServicePrincipalAppRole -OutVariable result |
            Should -Not -BeNullOrEmpty
        $result[0].getType().Name | Should -Be 'AppRole'
        $result[0].value | Should -Contain 'Exchange.ManageAsApp'
        $result[0].Id | Should -BeOfType ([Guid])
        $result[0].AppId | Should -Be $sp.Id
    }

    It 'Multiple service principal via pipeline' {
        $sp = (Get-AzADServicePrincipal -DisplayName 'office 365 exchange online'),
            (Get-AzADServicePrincipal -DisplayName 'office 365 sharepoint online')

        $sp | Get-AzAdServicePrincipalAppRole -OutVariable result |
            Should -Not -BeNullOrEmpty
        $result.Value | Should -Contain 'Exchange.ManageAsApp'
        $result.Value | Should -Contain 'Sites.ReadWrite.All'
        $result.AppId | Should -Contain $sp[0].id
        $result.AppId | Should -Contain $sp[1].id
    }

    It 'Fails to find fake guid' {
        { Get-AzAdServicePrincipalAppRole -Id 'ffffffff-ffff-ffff-ffff-ffffffffffff' } |
            Should -Throw '*NotFound*'
    }
}
