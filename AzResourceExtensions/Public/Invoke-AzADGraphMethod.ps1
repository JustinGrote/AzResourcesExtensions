using namespace Microsoft.Azure.Commands.Profile.Models
using namespace Microsoft.Powershell.Commands
using namespace System.Net.Http
function Invoke-AzADMSGraphMethod {

    param (
        #Target Path to Invoke
        [Parameter(Mandatory)][String]$Path,
        #Body of the request (if applicable)
        [Hashtable]$Body,
        [WebRequestMethod]$Method = 'Get',
        [Uri]$Endpoint = 'https://graph.microsoft.com/',
        [ValidateSet('v1.0','beta')][String]$Version = 'v1.0'
    )

    $ErrorActionPreference = 'Stop'

    #Trailing slash is essential due to bad URI combination work
    if ($Endpoint -notmatch '/$') {
        [Uri]$Endpoint = ([String]$Endpoint + '/')
    }

    $BaseUri = [Uri]::new($Endpoint, "$Version/")

    [SecureString]$Token = (Get-AzAccessToken -ResourceUrl $Endpoint).Token | 
        ConvertTo-SecureString -AsPlainText

    #Add Api Version
    $irmParams = @{
        URI = [Uri]::new($BaseUri, $Path)
        Body = $Body
        Method = $Method
        UseBasicParsing = $true
        Authentication = 'Bearer'
        Token = $Token
        ContentType = 'application/json'
    }

    # Invoke REST method and fetch data until there are no pages left.
    do {
        try {
            $Results = Invoke-RestMethod @irmParams
        } catch [HttpResponseException] {
            throw [InvalidOperationException](Format-GraphError $PSItem)
        }
        
        $QueryResults += if ($Results.value) {
            $Results.value
        } else {
            $Results
        }

        #Paging continue
        $irmParams.Uri = if ([uri]::IsWellFormedUriString($Results.'@odata.nextlink', 'Absolute')) {
            $Results.'@odata.nextlink'
        } else {
            $irmParams.Body = $null
        }

        $irmParams.Method = 'GET'
    } while (
        $null -ne $irmParams.Uri
    )

    # Return the result.
    $QueryResults
}