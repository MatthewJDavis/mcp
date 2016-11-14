break
#region subscriber db (if not already in place)
$resourceGroup = 'sql-replication-rg'
$sqlServerName = 'md-subscriber'
$databaseName = 'gemapp-subscriber'
$storageAccountName = 'sqlreplicationrgdisks574'
$databaseName = 'gemapp-replication'
$tier = 'S3'


#Create Subscriber SQL Server in existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroup

$subsriberSrvParams = @{ServerName = $sqlServerName; SqlAdministratorCredentials = Get-Credential;
                        ResourceGroupName = $resourceGroup.ResourceGroupName; Location = $resourceGroup.location; 
                        RequestedServiceObjectiveName = $tier; Tags = @{project='replication'}}

$subscriberServer = New-AzureRmSqlServer @subsriberSrvParams 

#Create Azure SQL Database

$subscirberDBParams = @{DatabaseName = $databaseName; Edition = 'Standard';  ServerName = $subscriberServer.ServerName;
                        ResourceGroupName = $subscriberServer.ResourceGroupName}
$subscriberDatabase = New-AzureRmSqlDatabase @subscirberDBParams

#endregion

#region Create SQL Server for Geo-Replication 
$repSqlServerName = 'sql-geo-rep-subscriber-srv'
$location = 'uksouth'

$repResourceGroup = New-AzureRmResourceGroup -Name 'sql-georeplication-rg' -Location $location -Tag @{project='replication'}

#Create new Azure SQL Server
$subsriberSrvParams = @{ServerName = $repSqlServerName; SqlAdministratorCredentials = Get-Credential;
                        ResourceGroupName = $repResourceGroup.ResourceGroupName; Location = $repResourceGroup.location; 
                        Tags = @{project='replication'}}

$repSqlServer = New-AzureRmSqlServer @subsriberSrvParams
#endregion

#region Set up geo replication

$secondaryDb = @{DatabaseName = $databaseName; ResourceGroupName = $resourceGroup.ResourceGroupName;
                 ServerName =  $sqlServerName; PartnerResourceGroupName = $repResourceGroup.ResourceGroupName;
                 PartnerServerName = $repSqlServerName; AllowConnections = "All"}

New-AzureRmSqlDatabaseSecondary @secondaryDb
#endregion

#region SQL Commands

<#


CREATE TABLE [dbo].[customer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[firstname] [nvarchar](50) NOT NULL,
	[surname] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

INSERT INTO dbo.customer (firstname, surname)
VALUES ('Shaq','Boss'),
	   ('Scottie','Pippen'),
	   ('Horace','Grant');
GO
#>

$params = @{
      'Database' = 'gemapp-replication'
      'ServerInstance' = 'md-subscriber.database.windows.net'
      'Username' = 'matt'
      'Password' = ''
      'OutputSqlErrors' = $true
      'Query' = 'SELECT * FROM dbo.customer'
}
Invoke-Sqlcmd @params
#endregion 

#region Copy Replicated Database

$dbCopyParams = @{DatabaseName = $databaseName; ServerName = $repSqlServerName;
                  ResourceGroupName = $repResourceGroup.ResourceGroupName; CopyResourceGroupName = $repResourceGroup.ResourceGroupName
                  CopyServerName = $repSqlServerName; CopyDatabaseName = "gemapp-rep"}

New-AzureRmSqlDatabaseCopy @dbCopyParams

#endregion 

#region Copy database to test site

$testResourceGroup = New-AzureRmResourceGroup -Name test-rg -Location ukwest -Tag @{project="replication test"}

$testSQLServer = New-AzureRmSqlServer -ServerName test1123-sql-srv -Location ukwest -ResourceGroupName $testResourceGroup.ResourcegroupName -SqlAdministratorCredentials (Get-Credential)

$dbTestParams = @{DatabaseName = "gemapp-rep"; ServerName = $repSqlServerName;
                  ResourceGroupName = $repResourceGroup.ResourceGroupName; CopyResourceGroupName = $testResourceGroup.ResourcegroupName
                  CopyServerName = "test1123-sql-srv"; CopyDatabaseName = "gemapp-test"}

New-AzureRmSqlDatabaseCopy @dbTestParams

