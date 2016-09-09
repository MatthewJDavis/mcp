#Create a resource group and deploy a VNET into it via a JSON template file

$rgName = "vnet-RG"
$location = "northeurope"

New-AzureRmResourceGroup -Name $rgName -Location $location -Tag  @{Project="VNET";Course="70-533"}

New-AzureRmResourceGroupDeployment -Name "office-vnet-deploy" -ResourceGroupName $rgName -Mode Incremental -TemplateFile "C:\git\mcp\70-533-Azure-infra-solutions\virtual-networks\office-azuredeploy.json"

New-AzureRmResourceGroupDeployment -Name "host-vnet-deploy" -ResourceGroupName $rgName -Mode Incremental -TemplateFile "C:\git\mcp\70-533-Azure-infra-solutions\virtual-networks\host-azuredeploy.json"

#Remove-AzureRmResourceGroup -Name $rgName -Force