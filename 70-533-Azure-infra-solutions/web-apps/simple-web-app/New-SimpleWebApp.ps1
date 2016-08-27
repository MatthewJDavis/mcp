##Create a simple web app

$resourceGroupName = "one-web-app-RG"
$location = "north europe"

#Login to Azure account
#Login-AzureRmAccount
#Select-AzureRmSubscription -SubscriptionName 

##Create the resource group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tags @{Project="Simple Web App";Course="70-533"}

#Create App Service plan
New-AzureRmAppServicePlan -ResourceGroupName "one-web-app-RG" -Name "Simple-Web-App" -Location $location -Tier Basic -NumberofWorkers 1 -WorkerSize "Small" 

#Create web app
New-AzureRmWebApp -ResourceGroupName "one-web-app-RG" -Name "matt-test-web-app" -Location $location -AppServicePlan "Simple-Web-App"


    