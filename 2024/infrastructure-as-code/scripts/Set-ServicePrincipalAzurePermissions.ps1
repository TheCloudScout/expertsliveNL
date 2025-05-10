<#
.DESCRIPTION
    This script will set appropriate permissions for Logic App, Data Explorer Clusters and Functions Managed Identities.

.PARAMETER SourceResourceGroupName <String>
    Resource Group where your  Apps reside in.

.PARAMETER TargetResourceGroupName <String>
    Resource Group to where assign permissions to.

.PARAMETER AzureRole <String>
    Define which Azure built-in role to assign i.e. Microsoft Sentinel Responder.
    Check the full list here: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

.PARAMETER AllResources <String>
    Assign rights to all apps. If not, set single resource managed identity

.PARAMETER AppName <String>
    Managed Identity name
#>

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
[CmdletBinding()]
param (
    [Parameter (Mandatory = $false)]
    [String] $SourceResourceGroupName,

    [Parameter (Mandatory = $true)]
    [String] $TargetResourceGroupName,

    [Parameter (Mandatory = $true)]
    [String] $AzureRole,

    [Parameter (Mandatory = $true)]
    [bool] $AllResources,

    [Parameter (Mandatory = $false)]
    [String] $AppName
)

if ($AllResources -eq $true) {
    # Create new object to collect all Managed Identities in. 
    $managedIdentities = @()

    # Collect all Logic Apps, Clusters and Functions with system-assigned managed identities. 
    $allLiveResources = Get-AzResource -ResourceGroupName $SourceResourceGroupName | `
        Where-Object { `
        ( $_.ResourceType -eq "Microsoft.Logic/workflows" -or $_.ResourceType -eq "Microsoft.Web/sites" -or $_.ResourceType -eq "Microsoft.Kusto/clusters") -and $null -ne $_.Identity.PrincipalId `
    }

    # Gather all Managed Identities objectIds
    foreach ($resource in $allLiveResources) {
        $retrieveId = New-Object PSObject -property @{
            # Retrieve Managed Identity objectId
            appName = $resource.Name
            id      = (Get-AzResource -ResourceId $resource.Id).Identity.PrincipalId
        }
        # Add hash table to already existing object with all the other workspaces
        $managedIdentities += $retrieveId
    }

    # Assign appropriate permissions
    foreach ($managedIdentity in $managedIdentities) {
        Write-Output "Assigning Managed Identity permission from [$($managedIdentity.appName)] to [$($TargetResourceGroupName)]."
        $paramHash = @{
            ObjectId           = $managedIdentity.id
            RoleDefinitionName = $AzureRole
            ResourceGroupName  = $TargetResourceGroupName
            WarningAction      = 'SilentlyContinue'
        }

        # Check if role is already assigned to avoid errors
        try {
            $RoleAssignment = Get-AzRoleAssignment @paramHash -ErrorAction stop
        }
        catch {
            Write-Host "##vso[task.logissue type=warning]An error occured while retrieving permissions for [$($managedIdentity.appName)]. Check if Managed Identity is enabled."
        }

        # Assign permissions to Managed Identities
        if ($null -eq $RoleAssignment) {
            try {
                $null = New-AzRoleAssignment @paramHash -ErrorAction stop
                Write-Output "Role [$($paramHash.RoleDefinitionName)] assigned"
            }
            catch {
                Write-Error "##vso[task.logissue type=error]An error occured while assigning [$($paramHash.RoleDefinitionName)] for [$($managedIdentity.appName)] to [$($paramHash.ResourceGroupName)]."
            }
        }
        else {
            Write-Output "Role [$($paramHash.RoleDefinitionName)] was already assigned"
        }

    }
}
else {

    $managedIdentity = Get-AzResource -Name $AppName
    Write-Output "Assigning Managed Identity permission from [$($managedIdentity.appName)] to [$($TargetResourceGroupName)]."
    $paramHash = @{
        ObjectId           = $managedIdentity.identity.principalId
        RoleDefinitionName = $AzureRole
        ResourceGroupName  = $TargetResourceGroupName
        WarningAction      = 'SilentlyContinue'
    }



    # Check if role is already assigned to avoid errors
    try {
        $RoleAssignment = Get-AzRoleAssignment @paramHash -ErrorAction stop
    }
    catch {
        Write-Host "##vso[task.logissue type=warning]An error occured while retrieving permissions for [$($managedIdentity.Name)]. Check if Managed Identity is enabled."
    }

    # Assign permissions to Managed Identities
    if ($null -eq $RoleAssignment) {
        try {
            $null = New-AzRoleAssignment @paramHash -ErrorAction stop
            Write-Output "Role [$($paramHash.RoleDefinitionName)] assigned"
        }
        catch {
            Write-Error "##vso[task.logissue type=error]An error occured while assigning [$($paramHash.RoleDefinitionName)] for [$($managedIdentity.Name)] to [$($paramHash.ResourceGroupName)]."
        }
    }
    else {
        Write-Output "Role [$($paramHash.RoleDefinitionName)] was already assigned"
    }
}