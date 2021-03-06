# Provide credentials
$Creds = Get-Credential `
            -Message 'Provide Azure Subscription Credentials...'

# Login to Azure
Login-AzureRmAccount `
    -Credential $Creds `
    -ErrorAction Stop | Out-Null

# Pick Subscription/TenantID
$Azure =
    (Get-AzureRmSubscription `
        -ErrorAction Stop |
     Out-GridView `
        -Title 'Select a Subscription/Tenant ID...' `
        -PassThru)

# Select Subscription
Select-AzureRmSubscription `
    -SubscriptionId $Azure.Id `
    -TenantId $Azure.TenantId `
    -ErrorAction Stop| Out-Null

# Automation Account Name

$AutomationAccountName = "OMSBook"
$ResouceGroupName = "InsideOMS"
$RunbookPath = "C:\InsideOMSv2\Chapter 6\runbooks\Install-MMA.ps1"
$HWG = "TestEnv"
$params = @{"Servername"="ONPREMVM";}

# Import Runbook

Import-AzureRmAutomationRunbook -Path $RunbookPath `
                                -Description "Installs MMA" `
                                -Name "Install-MMA" `
                                -Type PowerShellWorkflow `
                                -Published `
                                -Force `
                                -ResourceGroupName $ResouceGroupName  `
                                -AutomationAccountName $AutomationAccountName


# Start runbook job
Start-AzureRmAutomationRunbook -Name "Install-MMA" `
                               -Parameters $params `
                               -Wait `
                               -RunOn $HWG `
                               -ResourceGroupName $ResouceGroupName `
                               -AutomationAccountName $AutomationAccountName
