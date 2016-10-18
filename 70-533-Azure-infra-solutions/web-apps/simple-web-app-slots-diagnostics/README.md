# Simple Web App with deployment slots
The PowerShell script will create the follow resources in an Azure subscription:
- Resource Group
- App Service Plan
- Web App with the following slots: 
    - Production
    - Staging

It also enables diagnostics for the web app that are off by default.
The diagnostics enabled are:
-Web Server Logging (logged to file system)
-Detailed Error Messages
-Failed Trace Requests

To enable slots, you need to have at least a Standard app service plan which is chargable.
https://azure.microsoft.com/en-gb/pricing/details/app-service/plans/

The visio diagram simple-web-app-slots.vsdx gives a visual overview.