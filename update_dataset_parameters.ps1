# update_dataset_parameters.ps1

# Install the MicrosoftPowerBIMgmt module if it's not already installed
if (-not (Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable)) {
    Install-Module -Name MicrosoftPowerBIMgmt -Force -Scope CurrentUser
}
# update_dataset_parameters.ps1
# update_dataset_parameters.ps1

# Connect to the Power BI service
Connect-PowerBIServiceAccount

# Get the workspace ID and dataset ID (Replace with your workspace and dataset names)
$workspaceName = "96b1ab18-cd5e-4e01-8ffd-8bf59651f1bf"
$datasetName = "1e9f210c-d1b2-480c-8184-96c3938e1fef"

$workspace = Get-PowerBIWorkspace -Scope Organization | Where-Object { $_.Name -eq $workspaceName }
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id | Where-Object { $_.Name -eq $datasetName }

if ($workspace -eq $null -or $dataset -eq $null) {
    Write-Host "Workspace or dataset not found."
    exit 1
}

# Create JSON object with update details
$updateDetails = @(
    @{
        name = "EndDate"
        newValue = "2020-06-08"
    },
    @{
        name = "StartDate"
        newValue = "2020-06-01"
    }
)

$body = @{
    updateDetails = $updateDetails
} | ConvertTo-Json

# Specify the URL for updating parameters
$datasetId = $dataset.Id
$datasetParametersUrl = "/datasets/$datasetId/Default.UpdateParameters"

# Invoke the UpdateParameters operation
Invoke-PowerBIRestMethod -Url $datasetParametersUrl -Method Post -Body $body -ContentType "application/json"

# Refresh the dataset (Optional)
# Invoke-PowerBIRestMethod -Url "/datasets/$datasetId/refreshes" -Method Post

