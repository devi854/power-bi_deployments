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
