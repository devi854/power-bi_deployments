import requests
import json

# Replace these with your actual values
tenant_id = "0277ec7c-6485-4a45-9d8e-07a6941a7819"
client_id = "647b60eb-374e-4af1-b7c7-439ba4913814"
client_secret = "peA8Q~TGozmsgvf8dT3CF16mDlTVvOUuCufJ_aDF"

# Step 1: Authorize and Get Access Token
token_url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/token"
data = {
    "grant_type": "client_credentials",
    "client_id": client_id,
    "client_secret": client_secret,
    "resource": "https://analysis.windows.net/powerbi/api/"
}

response = requests.post(token_url, data=data)
access_token = json.loads(response.text)["access_token"]

# Step 2: Use Access Token to Update Dataset Parameters
headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

workspace_id = "96b1ab18-cd5e-4e01-8ffd-8bf59651f1bf"
dataset_id = "1e9f210c-d1b2-480c-8184-96c3938e1fef"
update_url = f"https://api.powerbi.com/v1.0/myorg/groups/{workspace_id}/datasets/{dataset_id}/Default.UpdateParameters"

parameters = {
    "updateDetails": [
        {
            "name": "Server",
            "newValue": "Server123"
        },
        {
            "name": "Database",
            "newValue": "datadb"
        }
    ]
}

response = requests.post(update_url, headers=headers, json=parameters)

if response.status_code == 200:
    print("Dataset parameters updated successfully.")
else:
    print("Error updating dataset parameters.")
    print(response.text)
