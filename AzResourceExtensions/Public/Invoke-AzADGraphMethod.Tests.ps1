#requires -module Az.Resources
BeforeAll {
    Import-Module $PSScriptRoot/../AzResourcesExtensions.psd1 -Force
}
Describe 'Invoke-AzADGraphMethod' {

    It "Works with defaults" {
        [guid](Invoke-AzADGraphMethod -Path 'me').id | 
            Should -BeOfType 'Guid'
    }
    It "Handles trailing slash path" {
        [guid](Invoke-AzADGraphMethod -Path '/me').id | 
            Should -BeOfType 'Guid'
    }
    It "Handles Resource Not Found" {
        {[guid](Invoke-AzADGraphMethod -Path 'notme').id} | 
            Should -Throw 'BadRequest: Resource not found for the segment*'
    }
}