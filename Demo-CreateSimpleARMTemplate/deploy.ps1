#Login-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionId ""

$location = "northcentralus"
$resourceGroupName = "stirtrek2016-webapp"

$templateFile = "C:\Projects\StirTrek2016\Demo-CreateSimpleARMTemplate\azuredeploy.json"
$templateParamFile = "C:\Projects\StirTrek2016\Demo-CreateSimpleARMTemplate\azuredeploy.parameters.json"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                    -TemplateFile $templateFile `
                                    -TemplateParameterFile $templateParamFile `
                                    -Mode Incremental `
                                    -Verbose -Debug

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                   -TemplateFile $templateFile `
                                   -TemplateParameterFile $templateParamFile
