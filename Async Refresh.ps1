#Requires -Modules @{ ModuleName="MicrosoftPowerBIMgmt"; ModuleVersion="1.2.1026" }

$groupId = "5176f617-bf38-4168-bed1-6072be7d332e"
$datasetId = "08bb7318-0d74-4516-885a-ee4cb9d76fe4"

$bodyJson = @"
{
  "type": "Full",
  "commitMode": "PartialBatch",
  "applyRefreshPolicy": "False",
  "objects": [
    {
      "table": "Batch Master",
      "partition": "2022Q20531"
    },
    {
      "table": "Batch Master",
      "partition": "2022Q20531"
    }
  ]
}
"@

Connect-PowerBIServiceAccount

# Refresh
Invoke-PowerBIRestMethod -url "groups/$groupId/datasets/$datasetId/refreshes" -Method Post -Body $bodyJson -ContentType "application/json"

$requestId = ""

# Refresh Status
$body = Invoke-PowerBIRestMethod -url "groups/$groupId/datasets/$datasetId/refreshes/$requestId" -Method Get | ConvertFrom-Json
$body
$body.objects

# Delete
Invoke-PowerBIRestMethod -url "groups/$groupId/datasets/$datasetId/refreshes/$requestId" -Method Delete

# Refreshes
(Invoke-PowerBIRestMethod -url "groups/$groupId/datasets/$datasetId/refreshes?`$top=5" -Method Get | ConvertFrom-Json).value
