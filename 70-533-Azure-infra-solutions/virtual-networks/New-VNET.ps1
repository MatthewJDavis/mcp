#Create a resource group and deploy a VNET into it via a JSON template file

New-AzureRmResourceGroup -Name "vnet-RG" -Location northeurope -Tag  @{Project="VNET";Course="70-533"}

New-AzureRmResourceGroupDeployment -Name "vnet-deploy" -ResourceGroupName "vnet-RG" -Mode Incremental -TemplateParameterFile ""