<#
This will create in the Azure subscription: Resource group with a tag, a standard tier app service plan, a web app with a staging slot and diagnostics enabled.
Requires Azure PowerShell: https://azure.microsoft.com/en-gb/documentation/articles/powershell-install-configure/

The web app name needs to be globally unique, if deployment of web app fails, try a different name or number at the end.

***For deployment slots, the Standard tier is required and is CHARGABLE- remember to remove the resource group when you no longer need the web app.

18th Oct 2016
Matthew Davis
#>

$resourceGroupName = 'simple-web-app-slots-rg'
$location = 'UK South'
$project = 'Web App with deployment slots'
$appServicePlanName = 'simple-web-app-slots-asp'
$tier = 'Standard' #Standard required to enable deployment slots
$workers = 1
$workerSize = 'Small'
$webAppName = 'simple-web-app-slots'

#region Check for Azure PowerShell
try{
    Get-Module -Name Azure -ListAvailable -ErrorAction Stop
} 
catch{
    $err = $Error[0]
}
#endregion

#region authenticate to Azure
Login-AzureRmAccount 
#endregion 


#region Create Resource group, App Service Plan & Web App
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tag @{Project=$project}

New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -Tier $tier -NumberofWorkers $workers -WorkerSize $workerSize -ResourceGroupName $resourceGroupName

New-AzureRmWebApp -Name $webAppName -ResourceGroupName $resourceGroupName -Location $location -AppServicePlan $appServicePlanName
#endregion

#region Add staging slot and enable diagnostics
New-AzureRmWebAppSlot -Name $webAppName -ResourceGroupName $resourceGroupName -Slot 'Staging'

Set-AzureRmWebApp -Name $webAppName -AppServicePlan $appServicePlanName -ResourceGroupName $resourceGroupName -RequestTracingEnabled $true -HttpLoggingEnabled $true -DetailedErrorLoggingEnabled $true
#endregion

#Uncomment the below to remove the resource group
#Remove-AzureRmResourceGroup -Name simple-web-app-slots-rg -Force