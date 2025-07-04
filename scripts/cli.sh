
# Variáveis
resourceGroup="rg-monitor"
vmName="vm-example"
actionGroupName="ag-alerts"
vmId=$(az vm show -g $resourceGroup -n $vmName --query id -o tsv)
# Criar alerta CPU > 80%
az monitor metrics alert create \
--name "CPU-High-Alert" \
--resource-group $resourceGroup \
--scopes $vmId \
--condition "avg Percentage CPU > 80" \
--description "CPU usage is above 80% for 5 minutes" \
--action "/subscriptions/<subscription-id>/resourceGroups/$resourceGroup/providers/microsoft.insights/actionGroups/$actionGroupName"

# Criar alerta baseado em Activity Log para exclusão de VM
az monitor activity-log alert create \
--name "VM-Deletion-Alert" \
--resource-group $resourceGroup \
--scopes "/subscriptions/<subscription-id>" \
--condition "category=\'Administrative\' and operationName=\'Microsoft.Compute/virtualMachines/delete\'" \
--action-group "/subscriptions/<subscription-id>/resourceGroups/$resourceGroup/providers/microsoft.insights/actionGroups/$actionGroupName"

