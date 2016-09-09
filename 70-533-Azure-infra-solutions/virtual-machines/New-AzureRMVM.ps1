#Azure Virtual Machines
#Creates and Azure 2016 SQL

#Get VM Image offers
$location = "northeurope"

Get-AzureRmVMImagePublisher -Location $location 

Get-AzureRmVMImageOffer -Location $location -PublisherName MicrosoftSQLServer

Get-AzureRmVMImageSku -Location $location -PublisherName MicrosoftSQLServer -Offer SQL2016-WS2012R2

   
## Global
$ResourceGroupName = "ps-vm-RG"
$Location = "UKSouth"
    
## Storage
$StorageName = "vmstorage2321"
$StorageType = "Standard_LRS"
    
## Network
$InterfaceName = "az-sql-server-pip"
$Subnet1Name = "Subnet1"
$VNetName = "ps-vm-VNET"
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"
    
## Compute
$VMName = "az-sql-server"
$ComputerName = "Server22"
$VMSize = "Standard_A2"
$OSDiskName = $VMName + "OSDisk"
    
# Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{project="PowerShell VM"}
    
# Storage
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location
    
# Network
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -DomainNameLabel "matt-sql232"
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $VNetSubnetAddressPrefix
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIp.Id
    
# Compute
    
## Setup local VM object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftSQLServer -Offer SQL2016-WS2012R2 -Skus Standard -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage
    
## Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine
    
#Add a data disk after creation
#
$vm = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMName
Add-AzureRmVMDataDisk -VM $vm -Name datadisk1 -VhdUri "https://vmstorage2321.blob.core.windows.net/vhd/data-disk-1.vhd" -DiskSizeInGB 500 -Lun 0 -CreateOption Empty

Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force