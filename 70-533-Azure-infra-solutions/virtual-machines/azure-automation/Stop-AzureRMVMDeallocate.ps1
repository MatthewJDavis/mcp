

$vms = Get-AzureRmVM

foreach ($vm in $vms)
{
    $vmStatus = Get-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status

    if($vmStatus.Statuses[1].Code -eq 'PowerState/stopped' -and $vmStatus.Statuses[0].Time -lt (Get-Date).AddMinutes(-60)){
        Write-Output 'Shutting Down'
    }
    #Write-Output $vmStatus.Statuses[0].Time | Where-Object -FilterScript {$vmStatus.Statuses[1].Code -eq 'PowerState/stopped'} 
   
   #Write-Output $vmStatus.Statuses[0].Time
   <# if($vmStatus.Statuses[0].Time -ge (get-date).AddMinutes(-10)){
        Write-Output 'Shutting down'
    }#>
}

#Get log files for when the vm was last started
Get-AzureRmLog -ResourceGroup vm-setup-rg -StartTime (Get-Date).AddHours(-4) | Where-Object operationname -EQ Microsoft.Compute/virtualMachines/start/action