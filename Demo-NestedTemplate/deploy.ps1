#Login-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionId ""

# TODO: Add logic to ensure nested template files are uploaded to blob storage.

$location = "northcentralus"
$resourceGroupName = "stirtrek2016-nested"

$templateStorageAccountName = "collierstirtrek"
$templateStorageAccountResourceGroupName = "stirtrek2016"

$templateFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-NestedTemplate\azuredeploy.json"
$templateParamFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-NestedTemplate\azuredeploy.parameters.json"

$ctx = New-AzureStorageContext -StorageAccountName $templateStorageAccountName `
                               -StorageAccountKey (Get-AzureRmStorageAccountKey -ResourceGroupName $templateStorageAccountResourceGroupName `
                                                                                -Name $templateStorageAccountName).Key1
$containerSasToken = (New-AzureStorageContainerSASToken -Container templates `
                                                        -Permission r `
                                                        -Protocol HttpsOnly `
                                                        -StartTime (Get-Date).AddMinutes(-2) `
                                                        -ExpiryTime (Get-Date).AddMinutes(15) `
                                                        -Context $ctx)

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

$cred = Get-Credential -Message "Provide the admin credentials."

Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                    -TemplateFile $templateFile `
                                    -adminPassword $cred.Password `
                                    -adminUsername $cred.UserName `
                                    -containerSasToken $containerSasToken `
                                    -TemplateParameterFile $templateParamFile -Mode Incremental -Verbose -Debug

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                   -TemplateFile $templateFile `
                                   -TemplateParameterFile $templateParamFile `
                                   -Name "nested-example" `
                                   -adminPassword $cred.Password `
                                   -adminUsername $cred.UserName `
                                   -containerSasToken $containerSasToken `
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

