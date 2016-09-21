#Create a VM in service manager (classic)

$cloudServiceName = "mdclassicvm01"
$location = "North Europe"

$size = "Small"
$vmName = "mdclassicvm01"

$imageFamily = "Windows Server 2012 R2 Datacenter"

$imageName = Get-AzureVMImage | Where-Object {$_.ImageFamily -eq $imageFamily} | Sort-Object -Property PublishedDate -Descending | Select-Object -ExpandProperty ImageName -First 1

$adminUser = "matt"
$password = "myPa55W0rd"

$storageName = "mattclassic3890"

New-AzureStorageAccount -StorageAccountName $storageName -Location $location

$subsName = (Get-AzureSubscription -Current).SubscriptionName
Set-AzureSubscription -SubscriptionName $subsName -CurrentStorageAccountName $storageName

New-AzureQuickVM -Windows -ServiceName $cloudServiceName -Name $vmName -ImageName $imageName -AdminUsername $adminUser -Password $password -Location $location -InstanceSize $size