--Server Firewall Rules (run against master database)
SELECT * FROM sys.firewall_rules

--Add a firewall rule to the Azure SQL Server
EXECUTE sp_set_firewall_rule @name = N'AllowAllWindowsAzureIps',
    @start_ip_address = '0.0.0.0', @end_ip_address = '0.0.0.0'

EXECUTE sp_delete_firewall_rule @name = N'AllowAllWindowsAzureIps'

--Database Firewall Rules
SELECT * FROM sys.database_firewall_rules

--Add a Firewall Rule to the database
EXECUTE sp_set_database_firewall_rule @name = N'AllowAllWindowsAzureIps',
    @start_ip_address = '0.0.0.0', @end_ip_address = '0.0.0.0'

--Delete Firewall rule from the database
EXECUTE sp_delete_database_firewall_rule @name = N'AllowAllWindowsAzureIps'
