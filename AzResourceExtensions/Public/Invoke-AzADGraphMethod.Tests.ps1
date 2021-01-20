#requires -module Az.Resources
Describe 'Invoke-AzADGraphMethod' {
    BeforeAll {
        . $PSScriptRoot/Invoke-AzADGraphMethod.ps1
        . $PSScriptRoot/../Private/Format-GraphError.ps1
    }
    It "Works with defaults" {
        [guid](Invoke-AzADGraphMethod -Path 'me').id | 
            Should -BeOfType 'Guid'
    }
    It "Handles Resource Not Found" {
        {[guid](Invoke-AzADGraphMethod -Path 'notme').id} | 
            Should -Throw 'BadRequest: Resource not found for the segment*'
    }
}