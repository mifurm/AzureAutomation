$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
Write-Output "Show Me Something"
$table = @{"test"="value"; "test1"="value1"}
$table
Write-Output "Show Me Something"
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags

$rgs=Get-AzureRmResourceGroup
$rg = $rgs[0]
$rg
$resources=Find-AzureRmResource -ResourceGroupNameContains "bmrg01"
$resources
$tags = $resources[1].Tags
$tags
Write-Output "tags1"
$tags["tag1"].Value
Write-Output "tags1"
$tags["tag1"]
Write-Output "contains key"
$tags.ContainsKey("tag1")


<#
$tags.Keys
foreach ($value in $tags.Values)
{
    $value
}
foreach ($key in $tags.Keys)
{
    $key
}#>
