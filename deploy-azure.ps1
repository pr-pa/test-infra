

#$tenantID=Read-Host -Prompt 'Input your server  name'

<# 

It is expected that you already have created a subscription and a resource group.
The user executing this script should have contributor role access or equivalent level of access to create below mentioned resources.

This script deploys 4 template files which deploy 4 azure resources, the resources need connectivity and hence its a request to not to change the execution flow of this script. 
You need to specify a complete path of each template file where you have downloaded the templates locally for the scrip to find those teamplate files.

EG: C:\scripts\deployvnet.json

#>

Import-Module az
$subid= Read-Host -Prompt 'Enter subscription Id where you want to deploe the resources'

$RG= Read-Host -Prompt 'Enter resource group where you want to deploy the resources'

$vnettemp= Read-Host -Prompt 'Enter complete path of deployvnet.json file'
$storagetemp= Read-Host -Prompt 'Enter complete path of deploystorage.json file'
$webapptemp= Read-Host -Prompt 'Enter complete path of deploywebapp.json file'
$cosmostemp= Read-Host -Prompt 'Enter complete path of deploycosmosdb.json file'
$auttemp= Read-Host -Prompt 'Enter complete path of deployautomation.json file'

$stoacc= Read-Host -Prompt 'Enter Uniquename ofr a storage account in lowercase'

$appname= Read-Host -Prompt 'Enter Uniquename ofr a storage account in lowercase'

Login-AzAccount

Set-AzContext -Subscription $subid

$outobj=New-AzResourceGroupDeployment -Name "deploynetworking" -ResourceGroupName $RG -TemplateFile $vnettemp

$SubnetIDs=$outobj.Outputs.Values.value

$stoobj=New-AzResourceGroupDeployment -Name "deploystorage1" -ResourceGroupName $RG -TemplateFile $storagetemp -storageAccountName $stoacc -subnetId $SubnetIDs[1] -ErrorAction SilentlyContinue

$webappobj=New-AzResourceGroupDeployment -Name "deploywebapp1" -ResourceGroupName $RG -TemplateFile $webapptemp -webAppName $appname -subnetId $SubnetIDs[0] -ErrorAction SilentlyContinue

$cosmos=New-AzResourceGroupDeployment -Name "deploycosmos" -ResourceGroupName $RG -TemplateFile $cosmostemp -subnetid $SubnetIDs[1] -ErrorAction SilentlyContinue

$autobj=New-AzResourceGroupDeployment -Name "deployautomation" -ResourceGroupName $RG -TemplateFile $auttemp -ErrorAction SilentlyContinue