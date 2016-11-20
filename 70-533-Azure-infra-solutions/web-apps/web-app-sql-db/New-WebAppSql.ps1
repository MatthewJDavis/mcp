<#
This will create in the Azure subscription: Resource group with 2 tags, app service plan, web app, Azure SQL server, Azure SQL database.
Requires Azure PowerShell: https://azure.microsoft.com/en-gb/documentation/articles/powershell-install-configure/

The web app name needs to be globally unique, if deployment of web app fails, try a different name or number at the end.

14th Nov 2016
Matthew Davis
#>

$resourceGroupName = 'web-app-sql-rg'
$location = 'UK South'
$project = 'Web App with SQL database'
$createBy = 'Matthew Davis'
$appServicePlanName = 'web-app-sql-asp'
$webAppName = 'web-app-sqlp-123'
$tier = 'Free'
$workers = 1
$workerSize = 'Small'
$sqlServerName = 'web-app-sql-srv'
$sqlDatabaseName = 'web-app-sql-db'
$dbEdition = 'Free'
$tier = 'F1'


#region Check for Azure PowerShell
try{	
	Get-Module -ListAvailable Azure -ErrorAction Stop
}catch
{
	$err = $Error[0]
}#endregion


#region authenticate to Azure
Add-AzureRmAccount 
#endregion 


#region Create Resource group, App Service Plan & Web App
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Tag @{Project= $project; 'Created By'= $createBy}

New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -Tier $tier -NumberofWorkers $workers -WorkerSize $workerSize -ResourceGroupName $resourceGroupName

New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName 
#endregion

#region Create SQL Server
$sqlServerParams = @{ServerName = $sqlServerName; Location = $location 
                    ResourceGroupName = $resourceGroupName; SqlAdministratorCredentials = Get-Credential;
                    Tags = @{project = "$project"; "Created By" = $createBy}
}
New-AzureRmSqlServer @sqlServerParams

#endregion

#region Create SQL Database
$sqlDatabaseParams = @{ DatabaseName = $sqlDatabaseName; ResourceGroupName = $resourceGroupName 
                        Edition = $dbEdition; ServerName = $sqlServerName; 
                        Tags = @{project = "$project"; "Created By" = $createBy}

}
New-AzureRmSqlDatabase @sqlDatabaseParams 
#endregion

#Uncomment the below to remove the resource group
#Remove-AzureRmResourceGroup -Name simple-web-app-rg -Force