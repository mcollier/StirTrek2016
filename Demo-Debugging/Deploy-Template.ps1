#Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionId "0bbbc191-0023-40aa-b490-5536b2182f46"

$location = "northcentralus"
$resourceGroupName = "stirtrek2016-debug-template"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                   -TemplateFile "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-Debugging\101-vm-with-rdp-port\azuredeploy.json" `
                                   -TemplateParameterFile "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-Debugging\101-vm-with-rdp-port\azuredeploy.parameters.json" `
                                   -Verbose `
                                   -DeploymentDebugLogLevel 



#Get the deployment operation logs. Can use Write-Host to print to the console.
$stuff = @()
$operations = Get-AzureRmResourceGroupDeploymentOperation -DeploymentName azuredeploy -ResourceGroupName $resourceGroupName

# Show it
$operations

# Show the request and response for a specific operation
$operations[0].Properties.Request
$operations[0].Properties.Response


# Write it all to a file to look at.
foreach($op in $operations)

{
    $stuff += $op.id
    $stuff += "Request:"
    $stuff += $op.Properties.Request | ConvertTo-Json -Depth 10
    $stuff +=  "Response:"
    $stuff += $op.Properties.Response | ConvertTo-Json -Depth 10
} 

$stuff | Out-File -FilePath c:\temp\debug.txt

notepad C:\temp\debug.txt



# Get logs for the resource group in the last 1 hour
Get-AzureRmLog -ResourceGroup $resourceGroupName

# Get logs for the resource group since a specific time
$startTime = (get-date).AddHours(-2).ToString('yyyy-MM-ddTHH:mm')
Get-AzureRmLog -ResourceGroup $resourceGroupName -StartTime $startTime

# Get the logs for a resource provider since a specific time
$startTime = (get-date).AddHours(-2).ToString('yyyy-MM-ddTHH:mm')
Get-AzureRmLog -ResourceProvider "Microsoft.Compute" -StartTime $startTime -Status Failed -DetailedOutput