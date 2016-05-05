#Login-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionId ""

$location = "northcentralus"
$resourceGroupName = "stirtrek2016-nested"

$templateFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-NestedTemplate\azuredeploy.json"
$templateParamFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-NestedTemplate\azuredeploy.parameters.json"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

$cred = Get-Credential -Message "Provide the admin credentials."

Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                    -TemplateFile $templateFile `
                                    -adminPassword $cred.Password `
                                    -adminUsername $cred.UserName `
                                    -TemplateParameterFile $templateParamFile -Mode Incremental -Verbose -Debug

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                   -TemplateFile $templateFile `
                                   -TemplateParameterFile $templateParamFile `
                                   -Name "nested-example" `
                                   -adminPassword $cred.Password `
                                   -adminUsername $cred.UserName `
                                   -DeploymentDebugLogLevel All `
                                   -Verbose

#Get the deployment operation logs. Can use Write-Host to print to the console.
$stuff = @()
$operations = Get-AzureRmResourceGroupDeploymentOperation -DeploymentName "nested-example" -ResourceGroupName $resourceGroupName

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

$stuff | Out-File -FilePath c:\temp\nested-debug.txt

notepad C:\temp\nested-debug.txt

