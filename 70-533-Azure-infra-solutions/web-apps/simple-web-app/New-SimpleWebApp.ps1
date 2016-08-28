##Create a simple web app
#Will create a one web app with a staging deployment slot
#Creates a web job

$resourceGroupName = "simple-web-app-RG"
$location = "north europe"
$servicePlanName = "Simple-Web-App"
$tier = "Standard"
$workerSize = "Small"
$webAppName = "matt-test-web-app"
$slot1 = "Staging"


#Login to Azure account
#Login-AzureRmAccount
#Select-AzureRmSubscription -SubscriptionName 

##Create the resource group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tags @{Project="Simple Web App";Course="70-533"}

#Create App Service plan
New-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName  -Name $servicePlanName -Location $location -Tier $tier -NumberofWorkers 1 -WorkerSize $workerSize 

#Create web app
New-AzureRmWebApp -ResourceGroupName $resourceGroupName  -Name $webAppName -Location $location -AppServicePlan $servicePlanName

#Create 2 deployment slots
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName  -Slot $slot1

#Swap slots
#Swap-AzureRmWebAppSlot -SourceSlotName $slot1 -DestinationSlotName "Production" -ResourceGroupName $resourceGroupName -Name $webAppName


# Remove-AzureRmResourceGroup -Name simple-web-app-RG -Force   