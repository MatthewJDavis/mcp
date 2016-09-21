#Create a web app using PowerShell
#Requires Azure PowerShell
#This will create a resource group, appservice plan, web app with a deployment slot and set diagnostics on
#Matthew Davis 21st Sept 2016

$location = "uksouth"
$rgName = "ps-web-app-rg"
$appServicePlanName = 'md-test-ps-asp'
$webAppName = 'md-test-web-10'

#New resource group
New-AzureRmResourceGroup -Name $rgName -Location $location -Tag @{project="PowerShell"}

#Create App Service Plan
New-AzureRmAppServicePlan -Location $location -Tier Standard -NumberofWorkers 2 -WorkerSize Small `
-ResourceGroupName $rgName -Name $appServicePlanName

#Create Web App
New-AzureRmWebApp -ResourceGroupName $rgName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName 

#Create App Slot
New-AzureRmWebAppSlot -ResourceGroupName $rgName -Name $webAppName -Slot 'staging' 

#Add debugging
Set-AzureRmWebApp -AppServicePlan $appServicePlanName -RequestTracingEnabled $true -HttpLoggingEnabled $true `
-DetailedErrorLoggingEnabled $true -ResourceGroupName $rgName -name $webAppName