workflow Stop-AzureRMVMTagged
{
    <#
    .DESCRIPTION
        A runbook that will shutdown and deallocate VMs that have a tag and value that is passed to the script.

    .NOTES
        AUTHOR: Matt Davis
        LASTEDIT: Nov 2016, 2016
#>

     Param(
        [Parameter(Mandatory=$true)]
        [String]
        $TagKey,

        [Parameter(Mandatory=$true)]
        [String]
        $TagValue
    )

    $connectionName = "AzureRunAsConnection"
    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

        "Logging in to Azure..."
        Add-AzureRmAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
        $vms = Get-AzureRmVM | Where-Object -FilterScript {$_.Tags.$TagKey -eq $TagValue}

        foreach ($vm in $vms)
        {
            Write-Output "Stopping $($vm.Name)"
            Stop-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force
        }
}