# Import the Power BI PowerShell module
Import-Module -Name MicrosoftPowerBIMgmt

# Set the service principal credentials
$clientId = "your_client_id"
$clientSecret = "your_client_secret"
$tenantId = "your_tenant_id"

# Authenticate using Azure AD service principal credentials
Connect-PowerBIServiceAccount -ServicePrincipal -Credential (New-Object PSCredential $clientId, (ConvertTo-SecureString $clientSecret -AsPlainText -Force)) -Tenant $tenantId

# Get the access token
$token = Get-PowerBIAccessToken -ClientId $clientId -ClientSecret $clientSecret -Tenant $tenantId

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

# Invoke the API call with the access token
Invoke-PowerBIRestMethod -Url $url -Method Post -Body $body -AccessToken $token

# Logout when done (optional)
# Disconnect-PowerBIServiceAccount
