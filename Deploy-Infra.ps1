$ErrorActionPreference = 'Stop'

#   LOAD SETTINGS  #
#Verify the OS Runner to access the right property in the settings.json file
if($IsLinux){
    $OSValue = 'linux'
}
else{
    $OSValue = 'windows'
}
#Load Settings
$Settings= Get-Content -Path settings.json | ConvertFrom-Json -ErrorAction Stop

#   LOAD VARIABLES  #
$CLISPAppId = $Settings.CLIAppId
$SubscriptionId = $Settings.SubscriptonId
$TenantId = $Settings.TenantId
$RG = $Settings.ResourceGroupName
$KeyvaultName = $Settings.KeyVaultName
$StorageAccountName = $Settings.StorageAccountName
$StorageAccountSKU = $Settings.StorageAccountSKU
$AccountIdMSI = ($Settings.OS | Where-Object value -eq $OSValue).AccountIdMSI

#   ACCESS OUR KEYVAULT FROM ARC MSI ENDPOINT  #
$KVToken = New-ARCAccessTokenMSI -Audience Keyvault
#Load the Azure CLI secret from KV (Remember: You can't sign-ins with Access Token directly with CLI)
$CLISPPassword = Get-KeyvaultSecretValue -KeyVaultName $KeyvaultName -SecretName $CLISPAppId -AccessToken $KVToken

#   CREATE OUR INFRASTRUCTURE  #
# Let's now create our storage account with CLI
az login --service-principal -u $CLISPAppId -p $CLISPPassword --tenant $TenantId
#Let's now create our Storage account thanks to: az find "create storage account"
az storage account create --location francecentral --name $StorageAccountName --resource-group $RG --sku $StorageAccountSKU

#   FOR FUN: GET AN ARM Access Token  #
$ARMToken = New-ARCAccessTokenMSI -Audience ARM
#Connect with our Self runner as MSI
Connect-AzAccount -AccessToken $ARMToken -AccountId $AccountIdMSI -Subscription $SubscriptionId
# Just read our storage account
Get-AzStorageAccount -ResourceGroupName $RG -Name $StorageAccountName -ErrorAction SilentlyContinue