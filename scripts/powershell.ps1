# Login no Azure
Connect-AzAccount
# Variáveis
$resourceGroup = "rg-monitor"
$vmName = "vm-example"
$actionGroupName = "ag-alerts"
$scope = "/subscriptions/<subscription-id>/resourceGroups/$resourceGroup/providers/Microsoft.Compute/virtualMachines/$vmName"
$actionGroupId = "/subscriptions/<subscription-id>/resourceGroups/$resourceGroup/providers/microsoft.insights/actionGroups/$actionGroupName"
# Criar regra de alerta para CPU > 80%
Add-AzMetricAlertRuleV2 -Name "CPU-High-Alert" -ResourceGroupName $resourceGroup `
-TargetResourceId $scope `
-WindowSize (New-TimeSpan -Minutes 5) `
-Frequency (New-TimeSpan -Minutes 1) `
-Condition @(New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" -TimeAggregation Average -Operator GreaterThan -Threshold 80) `
-ActionGroupId $actionGroupId `
-Severity 2 -Description "CPU usage is above 80% for 5 minutes"

# Variáveis para alerta de exclusão de VM
$alertName = "VM-Deletion-Alert"
$scopeSub = "/subscriptions/<subscription-id>"
$condition = New-AzScheduledQueryRuleSource -Query "AzureActivity | where OperationNameValue == 'Microsoft.Compute/virtualMachines/delete'" -DataSourceId $scopeSub
# $actionGroupId já definido acima
New-AzScheduledQueryRule -ResourceGroupName $resourceGroup -Name $alertName -Location "East US" `
-Action @(New-AzScheduledQueryRuleAction -ActionGroup $actionGroupId) `
-Description "Alert for VM deletion activity" `
-Enabled $true -Source $condition -ScheduleFrequencyInMinutes 5 -ScheduleTimeWindowInMinutes 5

