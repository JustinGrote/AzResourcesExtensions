#requires -module Az.Resources
Describe 'Get-AZADManagedIdentity' {
    BeforeAll {
        . $PSScriptRoot/Get-AZADManagedIdentity.ps1
    }
    It "Fetches all Identities" {
        Get-AZADManagedIdentity |
            Should -Not -BeNullOrEmpty
    }

    It "Fails to find fake guid" {
        {Get-AZADManagedIdentity -Id 'ffffffff-ffff-ffff-ffff-ffffffffffff'} |
            Should -Throw '*NotFound*'
    }
}
