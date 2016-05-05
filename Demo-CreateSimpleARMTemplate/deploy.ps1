#Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionId "0bbbc191-0023-40aa-b490-5536b2182f46"

$location = "northcentralus"
$resourceGroupName = "stirtrek2016-webapp"

$templateFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-CreateSimpleARMTemplate\azuredeploy.json"
$templateParamFile = "C:\Users\mcollier\Dropbox\Presentations\Work on Your ARM Strength\StirTrek 2016\Demo-CreateSimpleARMTemplate\azuredeploy.parameters.json"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -TemplateParameterFile $templateParamFile -Mode Incremental

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                   -TemplateFile $templateFile `
                                   -TemplateParameterFile $templateParamFile
