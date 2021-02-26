#Dummy script to generate the settings.json file
$settings = @{
    "ResourceGroupName" = "<your Resource Group Name>"
    "KeyVaultName" = "<your Keyvault Name>"
    "StorageAccountName" = "<your Storage account Name>"
    "StorageAccountSKU" = "Standard_GRS"
    "SubscriptonId" = "<your Subscription Id>"
    "TenantId" = "<your TenantId>"
    "CLIAppId" = "<your Azure CLI SP ClientId>"
    OS = @(
            @{
                value = 'linux'
                "AccountIdMSI" = "<your Linux self-hosted runner AppId>"
            },
            @{
                value = 'windows'
                "AccountIdMSI" = "<your Windows self-hosted runner AppId>"
            }
        )
}

$settings | ConvertTo-Json | Out-File -FilePath .\settings.json