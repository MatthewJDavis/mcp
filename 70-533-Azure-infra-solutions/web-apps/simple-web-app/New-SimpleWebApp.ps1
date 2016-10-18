<#
This will create in the Azure subscription: Resource group with 2 tags, app service plan and web app.
Requires Azure PowerShell: https://azure.microsoft.com/en-gb/documentation/articles/powershell-install-configure/

The web app name needs to be globally unique, if deployment of web app fails, try a different name or number at the end.

13th Oct 2016
Matthew Davis
#>

$resourceGroupName = 'simple-web-app-rg'
$location = 'UK South'
$project = 'Simple Web App'
$createBy = 'Your Name'
$appServicePlanName = 'simple-web-app-asp'
$webAppName = 'simple-web-app-123'
$tier = 'Free'
$workers = 1
$workerSize = 'Small'


#region Check for Azure PowerShell
try{	
	Get-Module -ListAvailable Azure -ErrorAction Stop
}catch
{
	$err = $Error[0]
}#endregion


#region authenticate to Azure
Login-AzureRmAccount 
#endregion 


#region Create Resource group, App Service Plan & Web App
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tag @{Project= $project; 'Created By'= $createBy}

New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -Tier $tier -NumberofWorkers $workers -WorkerSize $workerSize -ResourceGroupName $resourceGroupName

New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName 
#endregion

#Uncomment the below to remove the resource group
#Remove-AzureRmResourceGroup -Name simple-web-app-rg -Force