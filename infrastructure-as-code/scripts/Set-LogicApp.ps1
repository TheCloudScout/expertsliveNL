<#
.DESCRIPTION
    This script will deploy an LogicApp for Azure Sentinel.

.PARAMETER ResourceGroupName <String>
    Resource Group to deploy the LogicApp to.

.PARAMETER LogicAppTemplateFile <String>
    LogicApp template file.

.PARAMETER LogicAppParameterFile <String>
    File with the basic LogicApp parameter settings.

.PARAMETER SubscriptionId [String]
    Optional parameter to use a specific SubscriptionId instead of the default one.

.PARAMETER LogicAppDefinitionFile [String]
    LogicApp definition including the definition parameter section.

.PARAMETER LogAnalyticsResourceId [String]
    Optional parameter to send the diagnostics to.

.PARAMETER ApiTenantId [String]
    Optional parameter when required within the LogicAppDefinitionFile.

.PARAMETER ApiClientId [String]
    Optional parameter when required within the LogicAppDefinitionFile.

.PARAMETER ApiClientSecret [String]
    Optional parameter when required within the LogicAppDefinitionFile.

.PARAMETER EventHubConnectionString [String]
    Optional parameter when required within the LogicAppDefinitionFile.

.PARAMETER BlobAccountAccessKey [String]
    Optional parameter when required within the LogicAppDefinitionFile.
#>

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
[CmdletBinding()]
param (
    [Parameter (Mandatory = $true)]
    [String] $ResourceGroupName,

    [Parameter (Mandatory = $true)]
    [String] $LogicAppTemplateFile,

    [Parameter (Mandatory = $true)]
    [String] $LogicAppParameterFile,

    [Parameter (Mandatory = $false)]
    [String] $SubscriptionId = "",

    [Parameter (Mandatory = $false)]
    [String] $LogicAppDefinitionFile = "",

    [Parameter (Mandatory = $false)]
    [String] $LogAnalyticsResourceId = "",

    [Parameter (Mandatory = $false)]
    [String] $ApiTenantId = "",

    [Parameter (Mandatory = $false)]
    [String] $ApiClientId = "",

    [Parameter (Mandatory = $false)]
    [String] $ApiClientSecret = "",

    [Parameter (Mandatory = $false)]
    [String] $EventHubConnectionString = "",

    [Parameter (Mandatory = $false)]
    [String] $BlobAccountAccessKey = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if (![System.IO.File]::Exists($LogicAppTemplateFile)) {
    Write-Error "The file '$($LogicAppTemplateFile)' doesn't exists"
}
if (![System.IO.File]::Exists($LogicAppParameterFile)) {
    Write-Error "The file '$($LogicAppParameterFile)' doesn't exists"
}

$context = Get-AzContext
$profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new([Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile)
$token = $profileClient.AcquireAccessToken($context.Subscription.TenantId)
$headers = @{
    "Authorization" = "Bearer $($token.AccessToken)"
    "Content-Type"  = "application/json"
}

if (![System.String]::IsNullOrWhiteSpace($SubscriptionId)) {
    $context = Set-AzContext -SubscriptionId $SubscriptionId
}

$logicAppTemplate = [System.IO.File]::ReadAllText($LogicAppTemplateFile) | ConvertFrom-Json -AsHashtable

if (![System.String]::IsNullOrWhiteSpace($LogicAppDefinitionFile)) {
    if (![System.IO.File]::Exists($LogicAppDefinitionFile)) {
        Write-Error "The file '$($LogicAppDefinitionFile)' doesn't exists"
    }
    $index = $logicAppTemplate.resources.name.IndexOf("[parameters('workflowName')]")
    $logicAppDefinition = [System.IO.File]::ReadAllText($LogicAppDefinitionFile) | ConvertFrom-Json -AsHashtable
    $logicAppTemplate.resources[$index].properties.definition = $logicAppDefinition.definition
    if ($logicAppDefinition.ContainsKey("parameters")) {
        $logicAppTemplate.resources[$index].properties.parameters = $logicAppDefinition.parameters
    }
}

$deploymentName = "LogicApp-$([System.Guid]::NewGuid().Guid)"
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName
$logicAppParameterJson = [System.IO.File]::ReadAllText($LogicAppParameterFile) | ConvertFrom-Json -AsHashtable
$body = @{
    "properties" = @{
        "mode"       = "Incremental"
        "template"   = $logicAppTemplate
        "parameters" = $logicAppParameterJson.parameters
    }
}
# Log Anaylytics Resource Id
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "LogAnalyticsResourceId" })) -and ![System.String]::IsNullOrWhiteSpace($LogAnalyticsResourceId)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $LogAnalyticsResourceId }))
}
# Azure Sentinel credentials
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "apiTenantId" })) -and ![System.String]::IsNullOrWhiteSpace($ApiTenantId)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $ApiTenantId }))
}
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "apiClientId" })) -and ![System.String]::IsNullOrWhiteSpace($ApiClientId)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $ApiClientId }))
}
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "apiClientSecret" })) -and ![System.String]::IsNullOrWhiteSpace($ApiClientSecret)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $ApiClientSecret }))
}
# EventHub connection string
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "eventHubConnectionString" })) -and ![System.String]::IsNullOrWhiteSpace($EventHubConnectionString)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $EventHubConnectionString }))
}
# Blob access key
if (($keyName = ($logicAppTemplate.parameters.Keys | Where-Object -FilterScript { $_ -eq "blobAccountAccessKey" })) -and ![System.String]::IsNullOrWhiteSpace($BlobAccountAccessKey)) {
    $body.properties.parameters.Add($keyName, (@{ "value" = $BlobAccountAccessKey }))
}

# Add parameters to the template file
foreach ($keyName in $body.properties.parameters.Keys) {
    if (!$body.properties.template.parameters.ContainsKey($keyName)) {
        Write-Host "Add template parameter '$($keyName)' with type '$($body.properties.parameters.$keyName.value.GetType().Name)'"
        $body.properties.template.parameters.Add($keyName, (@{}))
        switch ($body.properties.parameters.$keyName.value.GetType().Name) {
            "Boolean" {
                $body.properties.template.parameters.$keyName.Add("type", "bool")
            }
            "String" {
                if ($keyName.ToLower().StartsWith("secret")) {
                    Write-Host "  String type is changed to securestring"
                    $body.properties.template.parameters.$keyName.Add("type", "securestring")
                } else {
                    $body.properties.template.parameters.$keyName.Add("type", "string")
                }
            }
            "Hashtable" {
                $body.properties.template.parameters.$keyName.Add("type", "object")
            }
            default {
                Write-Host "Unknown property type '$($body.properties.parameters.$keyName.value.GetType().Name)'"
            }
        }
    }
}

# Deploy the ARM template
$params = @{
    "Method"  = "Put"
    "Uri"     = "https://management.azure.com$($resourceGroup.ResourceId)/providers/Microsoft.Resources/deployments/$($deploymentName)?api-version=2020-06-01"
    "Headers" = $headers
    "Body"    = $body | ConvertTo-Json -Depth 99 -Compress
}
Write-Host "Start deployment '$($deploymentName)'"
$deployment = Invoke-RestMethod @params -UseBasicParsing

$params = @{
    "Method"  = "Get"
    "Uri"     = "https://management.azure.com$($resourceGroup.ResourceId)/providers/Microsoft.Resources/deployments/$($deploymentName)?api-version=2020-10-01"
    "Headers" = $headers
}
do {
    Start-Sleep -Seconds 1
    $deployment = Invoke-RestMethod @params -UseBasicParsing
    Write-Verbose "Deployment status: $($deployment.properties.provisioningState)"
} while ($deployment.properties.provisioningState -in @("Accepted", "Created", "Creating", "Running", "Updating"))

if ($deployment.properties.provisioningState -eq "Succeeded") {
    Write-Host "Deployment '$($deploymentName)' completed with the status '$($deployment.properties.provisioningState)'"
    Write-Host "logicAppResourceId: $($deployment.properties.outputs.logicAppResourceId.value)"
    Write-Host "logicAppCallbackUrl: ***"
    Write-Host "##vso[task.setvariable variable=logicAppResourceId;isOutput=true;]$($deployment.properties.outputs.logicAppResourceId.value)"
    Write-Host "##vso[task.setvariable variable=logicAppCallbackUrl;isOutput=true;issecret=true;]$($deployment.properties.outputs.logicAppCallbackUrl.value)"
} else {
    Write-Host "##vso[task.logissue type=error;]Deployment status: $($deployment.properties.provisioningState)"
    if ($null -ne ($deployment.properties | Get-Member -MemberType NoteProperty -Name "error")) {
        $deployment.properties.error | ConvertTo-Json -Depth 99
    }
    Write-Error "Failed to deploy LogicApp."
}
