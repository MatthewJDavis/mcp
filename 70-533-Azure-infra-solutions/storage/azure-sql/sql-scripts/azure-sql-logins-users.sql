--Create a login in the virtual master database
 CREATE LOGIN username WITH PASSWORD = '';

 --Create a user in the virtual master database
 CREATE USER username FROM LOGIN username; 

 --Add user to dbmanager role
 ALTER ROLE dbmanager ADD MEMBER username; 

--Create a SQL self contain login for a database
CREATE USER datareader WITH PASSWORD = '';

-- Add user to the database owner role
EXEC sp_addrolemember N'db_datareader', N'datareader';
GO

--view SQL Server logins
SELECT * FROM sys.sql_logins;

--view database users
SELECT * FROM sys.sysusers;

--View users and roles
SELECT pr.principal_id, pr.name, pr.type_desc,   
    pr.authentication_type_desc, pe.state_desc, pe.permission_name  
FROM sys.database_principals AS pr  
JOIN sys.database_permissions AS pe  
    ON pe.grantee_principal_id = pr.principal_id;  