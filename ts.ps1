$sourceDatasetGroupId = "96b1ab18-cd5e-4e01-8ffd-8bf59651f1bf"
$sourceDatasetId = "1e9f210c-d1b2-480c-8184-96c3938e1fef"
$clientId = "your_client_id"  # Replace with your client ID

# Function to get the authentication token
function GetAuthToken {
    $clientId = "your_client_id"  # Replace with your client ID
    $clientSecret = "your_client_secret"  # Replace with your client secret
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    $resourceAppIdURI = "https://analysis.windows.net/powerbi/api"
    $authority = "https://login.microsoftonline.com/common/oauth2/authorize"

    # Use the ADAL PowerShell module to acquire the token
    Import-Module -Name "AzureRM.Profile" -Force
    $authContext = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext]$authority
    $authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "Always")
    
    return $authResult
}

# Get the authentication token
$token = GetAuthToken
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'=$token.CreateAuthorizationHeader()
}

$sourceGroupPath = "myorg/groups/$sourceDatasetGroupId"  # Modify this as needed

# Define the parameters to update
$body = @{
    updateDetails = @(
        @{
            name = "Server"
            newValue = "advanceddev"
        },
        @{
            name = "Database"
            newValue = "Sqldatabase"
        }
    )
}

$jsonPostBody = $body | ConvertTo-Json

$uri = "https://api.powerbi.com/v1.0/$sourceGroupPath/datasets/$sourceDatasetId/updateParameters"

# Make the API request to update dataset parameters
Invoke-RestMethod -Uri $uri -Headers $authHeader -Method POST -Body $jsonPostBody -Verbose

