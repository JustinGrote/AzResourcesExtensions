using namespace System.Management.Automation
$MSIHelper = {

    Write-Host -fore Gray 'ARGS'
    $i = 0
    $args.foreach{
        "$i $args[$i]"
        $i++
    }
    # Write-Host -fore Gray '===Command==='
    # $commandName | Write-Host -fore darkgreen
    # Write-Host -fore Gray '===Parameter==='
    # $parameterName | Write-Host -fore darkcyan
    # Write-Host -fore Gray '===WordToComplete==='
    # $wordToComplete | Write-Host -fore darkyellow
    # Write-Host -fore Gray '===CommandAst==='
    # $commandAst | ft | Out-String | Write-Host -fore magenta
    # Write-Host -fore Gray '===fakeBoundParameters==='
    # $fakeBoundParameters | ft | out-string | write-host -fore green

    'test1','test2','not' | where {$PSItem -like "$WordToComplete*"}
}
Register-ArgumentCompleter -CommandName New-AzureADServiceAppRoleAssignment -ParameterName ObjectId -ScriptBlock $MSIHelper