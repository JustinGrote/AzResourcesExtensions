#requires -module Az.Resources
BeforeAll {
    Import-Module $PSScriptRoot/../AzResourcesExtensions.psd1 -Force
}
Describe 'Get-AZADManagedIdentity' {
    It "Fetches all Identities" {
        Get-AZADManagedIdentity -OutVariable Result |
            Should -Not -BeNullOrEmpty
        $Result.ServicePrincipalType.foreach{
            $PSItem | Should -Be 'ManagedIdentity'
        }
    }
    
    It "Fails to find fake guid" {
        {Get-AZADManagedIdentity -Id 'ffffffff-ffff-ffff-ffff-ffffffffffff'} |
            Should -Throw 'Request_ResourceNotFound*'
    }
}
