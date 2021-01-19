Describe 'Set-AzManagedIdentityRoleAssignment' {
    BeforeAll {
        . $PSScriptRoot/New-AzManagedIdentityRoleAssignment.ps1
    }
    It "Fails if no identity provided and interactive not specified" {
        {New-AzManagedIdentityRoleAssignment} | 
            Should -Throw 'You must provide a service identity to act upon, either by its objectID, via the pipeline, or via the -Interactive switch'
    }
    It "Fails if Interactive specified but no interactive options exist" {
        Mock Get-Command {}
        {New-AzManagedIdentityRoleAssignment -Interactive} | 
            Should -Throw '-Interactive was specified but neither Out-Gridview or Out-ConsoleGridview was found. Hint: Install-Module Microsoft.Powershell.ConsoleGuiTools'
    }
    It "Object ID" {
        $TestGuid = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
        Mock Get-AzureADServicePrincipal -ParameterFilter {$ObjectId -eq $TestGuid}  {
            throw 'MatchedTestGuid'
        }
        {New-AzManagedIdentityRoleAssignment -ObjectID $TestGuid} | Should -Throw 'MatchedTestGuid'
    }

    It "GUI Interactive Path" {
        function Out-Gridview {}
        Mock Out-Gridview {}
        Mock Get-AzureADServicePrincipal -ParameterFilter {$Filter -eq "servicePrincipalType eq 'ManagedIdentity'"}  {
            throw 'OutGridViewPathTaken'
        }
        {New-AzManagedIdentityRoleAssignment -Interactive -InteractiveMode GUI} |
            Should -Throw 'OutGridViewPathTaken'
    }
}
