using namespace System.Management.Automation
function format-GraphError ([ErrorRecord]$ErrorRecord) {
    $errorDetails = ($ErrorRecord.ErrorDetails.Message | ConvertFrom-Json).Error
    "$($errorDetails.code)`: $($errorDetails.message)"
}