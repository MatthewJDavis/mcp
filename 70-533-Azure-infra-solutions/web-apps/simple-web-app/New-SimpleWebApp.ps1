<#

#>

$resourceGroupName = 'simple-web-app-rg'
$location = 'UK South'
$appServicePlanName = 'simple-asp'
$webAppName = 'simple-web-app-123'

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tag @{Project='Simple Web App'; 'Created By'='Me'}

New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -Tier Free -NumberofWorkers 1 -WorkerSize Small -ResourceGroupName $resourceGroupName

New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName 

Set-AzureRmWebApp -AppServicePlan $appServicePlanName -Name $webAppName -HttpLoggingEnabled -RequestTracingEnabled -DetailedErrorLoggingEnabled