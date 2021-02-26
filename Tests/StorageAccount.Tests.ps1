#requires -modules @{ModuleName="Pester"; ModuleVersion="5.1.0"}
Describe 'Test StorageAccount' {
    BeforeAll {
        # Load settings
        #$Settings=Get-Content -Path $SettingsPath| ConvertFrom-Json -ErrorAction Stop
        if($IsLinux){
            $OSValue = 'linux'
        }
        else{
            $OSValue = 'windows'
        }
        $parentPath = Split-Path -Path $PSScriptRoot -Parent
        $SettingsPath = Join-Path $parentPath settings.json

        #Load Settings
        $Settings= Get-Content -Path $SettingsPath | ConvertFrom-Json -ErrorAction Stop


        # Define variables
        $AccountIdMSI = $(($Settings.OS | Where-Object value -eq $OSValue).AccountIdMSI)
        $SubscriptionId = $Settings.SubscriptonId
        $RG = $Settings.ResourceGroupName
        $StorageAccountName = $Settings.StorageAccountName
        $SCRIPT:StorageAccountSKU = $Settings.StorageAccountSKU

        # Load context and infrastructure
        $ARMToken = New-ARCAccessTokenMSI -Audience ARM
        Connect-AzAccount -AccessToken $ARMToken -AccountId $AccountIdMSI -Subscription $SubscriptionId
        $SCRIPT:StorageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $RG -ErrorAction SilentlyContinue
    }

     It 'Is Storage account exist' {
        $SCRIPT:StorageAccount| Should -Not -be $null
     }

     It 'Is Storage account SKU properly configured' {
        $SCRIPT:StorageAccount.Sku.Name| Should -be $SCRIPT:StorageAccountSKU
     }
 }