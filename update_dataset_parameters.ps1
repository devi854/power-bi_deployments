# update_dataset_parameters.ps1

# Install the MicrosoftPowerBIMgmt module if it's not already installed
if (-not (Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable)) {
    Install-Module -Name MicrosoftPowerBIMgmt -Force -Scope CurrentUser
}
# update_dataset_parameters.ps1
# update_dataset_parameters.ps1

# Parameters
$clientId = $env:POWER_BI_CLIENT_ID
$clientSecret = $env:POWER_BI_CLIENT_SECRET
$tenantId = $env:POWER_BI_TENANT_ID
$workspaceName = $env:POWER_BI_WORKSPACE_NAME
$datasetName = $env:POWER_BI_DATASET_NAME

# Authenticate using Service Principal
$secPassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object PSCredential $clientId, $secPassword

# Log in with Service Principal credentials
Login-PowerBIServiceAccount -ServicePrincipal -Credential $credential -Tenant $tenantId

# Get the Power BI workspace
$workspace = Get-PowerBIWorkspace -Name $workspaceName -Scope Organization

# Get the dataset within the workspace
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id -Scope Organization | Where-Object Name -eq $datasetName

# Create REST URL to update State parameter for the dataset
$datasetParametersUrl = "https://api.powerbi.com/v1.0/myorg/groups/$($workspace.Id)/datasets/$($dataset.Id)/Default.UpdateParameters"

# Define the parameter name and new value
$parameterName = "myserver"
$newParameterValue = "mydb"

# Create JSON for the POST body to update dataset parameters
$postBody = @{
    updateDetails = @(
        @{
            name = $parameterName
            newValue = $newParameterValue
        }
    )
} | ConvertTo-Json

# Invoke POST operation to update dataset parameters
Invoke-RestMethod -Uri $datasetParametersUrl -Method Post -Headers @{
    'Authorization' = "Bearer $((Get-PowerBIAccessToken).AccessToken)"
} -Body $postBody -ContentType 'application/json'

# If parameter updates change connection information (e.g., server path, database name),
# you may need to patch datasource credentials before refreshing the dataset

# Log out to end the session (optional)
# Logout-PowerBIServiceAccount
