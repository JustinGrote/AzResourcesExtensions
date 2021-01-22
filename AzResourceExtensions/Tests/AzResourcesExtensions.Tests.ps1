Describe 'AzResourcesExtensions' {
    BeforeAll {
        Import-Module (Resolve-Path $PSScriptRoot\..) -Force
    }

    It 'Can fetch an app role from a managed identity' {
        $sp = Get-AzADServicePrincipal -IncludeTotalCount
        $appRole = $sp | Get-AzAdAppRole
    }
}