# update_dataset_parameters.ps1

# Import the Power BI PowerShell module
Import-Module -Name MicrosoftPowerBIMgmt

# Set the service principal credentials
$clientId = "647b60eb-374e-4af1-b7c7-439ba4913814"
$clientSecret = "peA8Q~TGozmsgvf8dT3CF16mDlTVvOUuCufJ_aDF"
$tenantId = "0277ec7c-6485-4a45-9d8e-07a6941a7819"

# Authenticate using Azure AD service principal credentials
Connect-PowerBIServiceAccount -ServicePrincipal -Credential (New-Object PSCredential $clientId, (ConvertTo-SecureString $clientSecret -AsPlainText -Force)) -Tenant $tenantId

# Set the dataset id and the parameter name and value
$datasetId = "1e9f210c-d1b2-480c-8184-96c3938e1fef"
$parameterName = "StartDate"
$parameterValue = "2021-10-01"

# Create the URL and the body for the API call
$url = "https://api.powerbi.com/v1.0/myorg/datasets/$datasetId/parameters"
$body = @{
    updateDetails = @(
        @{
            name = $parameterName
            newValue = $parameterValue
        }
    )
} | ConvertTo-Json

# Invoke the API call with the URL and the body
Invoke-PowerBIRestMethod -Url $url -Method Post -Body $body
