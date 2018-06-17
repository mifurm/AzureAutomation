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

$rgs = Get-AzureRmResourceGroup
foreach ($rg in $rgs){
  if ($rg.Tags.Count -ne 0){
    $rgName = $rg.ResourceGroupName
    $msg="ResourceGroupName: $rgName"
    Write-Output $msg
    $resource=Find-AzureRmResource -ResourceGroupNameContains $rg.ResourceGroupName
    foreach ($rs in $resource){
          $rsName = $rs.Name
          $msg="Writing ResourceTags for resource: $rsName "
          Write-Output $msg
          $tagsCount = $rs.Tags.Count
          $msg = "#Tags before: $tagsCount"
          Write-Output $msg
          Try{
            $resourcetags = (Get-AzureRmResource -ResourceId $rs.ResourceId).Tags
            $msg = "Efective Tags" 
            Write-Output $msg
            $resourcetags
            $msg2 = "Tags from RG"
            Write-Output $msg2
            $rg.Tags
            foreach ($key in $rg.Tags.Keys){
                Write-Output "key"
                $key
                Write-Output "keys"
                $rg.Tags.Keys
                if (($resourcetags) -AND ($resourcetags.ContainsKey($key))) { $resourcetags.Remove($key) }
            } 
            $resourcetags += $rg.Tags; 
            $output=Set-AzureRmResource -ResourceId $rs.ResourceId -Tag $resourcetags -Force 
          }
          Catch{
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            $rsName = $rs.Name
            Write-Output $ErrorMessage
            Write-Output $FailedItem 
            $msg = "There was a problem writing Tags to resource: $rsName"
            Write-Output $msg
          }
          $tagsCount = $output.Tags.Count
          $msg = "#Tags after: $tagsCount"
          Write-Output $msg
    }
  }
}
