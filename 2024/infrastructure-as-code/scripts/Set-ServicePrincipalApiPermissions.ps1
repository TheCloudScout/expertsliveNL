# UPDATED 2024 April 30th to become compatible with PowerShell Core (.NET) version 7 and up.
# Now also runs on Linux and MacOS! 😎

# Fill in your own tenant ID
$tenantId = "ac7066bf-e218-42a2-b3bb-898b784b76a4"

# Name of the manage identity (same as the Logic App name)
# You can add a single or multiple managed identities

$displayNameOfManagedIdentity = @(
    "la-respond-auto-endpoint-investigation"
)

# Provide the Microsoft Graph permissions you'd like to assign to the managed identity
$graphPermissions = @(
    "Domain.Read.All",
    "User.Read.All" 
)
# Provide the Windows Defender ATP permissions you'd like to assign to the managed identity
$defenderPermissions = @(
    "AdvancedQuery.Read.All",
    "Alert.Read.All",
    "Alert.ReadWrite.All",
    "File.Read.All",
    "IntegrationConfiguration.ReadWrite",
    "Ip.Read.All",
    "Library.Manage",
    "Machine.CollectForensics",
    "Machine.Isolate",
    "Machine.LiveResponse",
    "Machine.Read.All",
    "Machine.ReadWrite.All",
    "Machine.RestrictExecution",
    "Machine.Scan",
    "Machine.StopAndQuarantine",
    "RemediationTasks.Read.All",
    "Score.Read.All",
    "SecurityBaselinesAssessment.Read.All", 
    "SecurityRecommendation.Read.All",
    "Software.Read.All",
    "Ti.ReadWrite.All",
    "Url.Read.All",
    "User.Read.All",
    "Vulnerability.Read.All"
)
# Provide the Microsoft Threat Protection permissions you'd like to assign to the managed identity
$threatIntelPermissions = @(
    "AdvancedHunting.Read.All",
    "CustomDetections.ReadWrite.All",
    "Incident.ReadWrite.All",
    "Incident.Read.All"
)

$ErrorActionPreference = "Stop" # Stop on all errors
Set-StrictMode -Version Latest  # Stop on uninitialized variables

Clear-Host

#### Function defined for displaying status messages in a nice and consistent way
    function Write-Message {
        param (
            [String]    $type = "header",           # user either 'header', 'item' or 'counter'
            [String]    $icon = "-",                # icon to display in header. only used when $type = 'header'
            [Int32]     $level = 0,                 # defines the level of indentation
            [String]    $message,                   # message to display
            [Int32]     $countMax = 0,              # defines first number and current item. i.e. 16/##. only used when $type = 'counter'
            [Int32]     $countMin = 0,              # defines second number and total items. i.e. ##/20. only used when $type = 'counter'
            [String]    $color1 = "Magenta",        # color of brackets
            [String]    $color2 = "White",          # color of icons and numbers
            [String]    $color3 = "Gray"            # color of message
        )

        # Generate leading spaces
        if ($level -gt 0) {
            $spaces = 0
            do {
                Write-Host "      " -NoNewLine;
                $spaces ++
            } until (
                $spaces -eq $level
            )
        }
        

        Switch ($type) {
            'header'.ToLower() {
                Write-Host "[ " -ForegroundColor $color1 -NoNewLine; Write-Host $icon -ForegroundColor $color2 -NoNewLine; Write-Host " ] " -ForegroundColor $color1 -NoNewLine;
            }
            'counter'.ToLower() {
                Write-Host "[ " -ForegroundColor $color1 -NoNewLine; Write-Host $CountMin -ForegroundColor $color2 -NoNewLine; Write-Host " / " -ForegroundColor $color2 -NoNewLine; Write-Host $CountMax -ForegroundColor $color2 -NoNewLine; Write-Host " ] " -ForegroundColor $color1 -NoNewLine;
            }
            'item'.ToLower() {
                Write-Host "  └─  " -ForegroundColor $color2 -NoNewLine;
            }
        }

        # Generate message
        Write-Host "$message" -ForegroundColor $color3
    }

#### Make sure all PowerShell modules are installed

    $modulesToInstall = @(
        'Microsoft.Graph.Applications'
    )

    Write-Message -icon "💾" -message "Checking if required PowerShell modules are available..."
    $modulesToInstall | ForEach-Object {
        if (-not (Get-Module -ListAvailable $_)) {
            Write-Message -type "item" -message "Module [$_] not found, installing..."
            try {
                Install-Module $_ -Force -ErrorAction Stop
                Write-Message -type "item" -level 1 -message "Module [$_] installed." -color3 Green
            }
            catch {
                Write-Message -type "item" -message "Failed to install Yaml module: $($_.Exception.Message)" -color3 Red
                Write-Host ""
                exit
            }
            Install-Module $_ -Force -ErrorAction Stop
        }
        else {
            Write-Message -type "item" -level 1 -message "Module [$_] already installed." -color3 Green
        }
    }

    $modulesToInstall | ForEach-Object {
        if (-not (Get-InstalledModule $_)) {
            Write-Message -type "item" -message "Module [$_] not loaded, importing..."
            try {
                Import-Module $_ -Force
                Write-Message -type "item" -level 1 -message "Module [$_] loaded." -color3 Green
            }
            catch {
                Write-Message -type "item" -message "Failed to load Yaml module: $($_.Exception.Message)" -color3 Red
                Write-Host ""
                exit
            }
            Import-Module $_ -Force
        }
        else {
            Write-Message -type "item"  -level 1 -message "Module [$_] already loaded." -color3 Green
        }
    }
Write-Host ""

# Authenticate to Microsoft Graph using Device Authentication
Write-Message -icon "🔐" -message "Authenticating to Microsoft Graph"
Write-Message -type item  -level 1 -message "Please sign-in to Azure..."

# Initialize device authentication to Microsoft Graph
$authority  = "https://login.microsoftonline.com"
$clientId   = "1950a258-227b-4e31-a9cf-717495945fc2"

$params = @{
    "Method" = "Post"
    "Uri"    = "$($authority)/$($tenantId)/oauth2/devicecode"
    "Body"   = @{
        "client_id"         = $clientId
        "ClientRedirectUri" = "urn:ietf:wg:oauth:2.0:oob"
        "Resource"          = "https://graph.microsoft.com/"
        "ValidateAuthority" = "True"
    }
}

$request = Invoke-RestMethod @params

Write-Message -type item -level 2 -message "Please visit    : $($request.verification_url)"
Write-Message -type item -level 2 -message "...and use code : $($request.user_code) (already copied to your clipboard)"

Set-Clipboard -Value $request.user_code
$params = @{
    "Method" = "Post"
    "Uri"    = "$($authority)/$($tenantId)/oauth2/token"
    "body"   = @{
        "grant_type" = "urn:ietf:params:oauth:grant-type:device_code"
        "code"       = $request.device_code
        "client_id"  = $clientId
    }
}

# Wait for authentication
$timeoutTimer = [System.Diagnostics.Stopwatch]::StartNew()
do {
    Start-Sleep -Seconds 1
    $token = $null
    if ($timeoutTimer.Elapsed.TotalSeconds -ge $request.expires_in) {
        throw "Login timed out, please try again."
    } try {
        $token = Invoke-RestMethod @params
    } catch {
        $message = $_.ErrorDetails.Message | ConvertFrom-Json
        if ($message.error -ne "authorization_pending") {
            throw
        }
    }
} while ([System.String]::IsNullOrWhiteSpace($token) -or [System.String]::IsNullOrWhiteSpace($token.access_token))
$timeoutTimer.Stop()

try {
    $token = (Invoke-RestMethod @params).access_token | ConvertTo-SecureString -AsPlainText -Force
    Write-Message -type item -level 3 -message "Token successfully retrieved" -color3 "Green"
}
catch {
    Write-Message -icon "⛔️" -level 3 -message "Something went wrong while retrieving your token :-( Error: $($_.Exception.Message)" -color3 "Red"
    exit
}

try {
    Connect-MgGraph -AccessToken $token -NoWelcome
    Write-Message -type item -level 3 -message "Connected to Microsoft Graph" -color3 "Green"
}
catch {
    Write-Message -icon "⛔️" -level 3 -message "Something went wrong while connecting to Microsoft Graph :-( Error: $($_.Exception.Message)" -color3 "Red"
    exit
}
Write-Host ""

# Retrieve resourceIds and appRoleIdsfor Microsoft Graph, WindowsDefenderATP and Microsoft Threat Protection
try {
    $graphServicePrincipal          = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'" | Select-Object @{N='resourceId'; E={$_.Id}} -ExpandProperty AppRoles | Select-Object resourceId, @{N='appRoleId'; E={$_.Id}}, @{N='displayName'; E={$_.Value}}
    $defenderServicePrincipal       = Get-MgServicePrincipal -Filter "appId eq 'fc780465-2017-40d4-a0c5-307022471b92'" | Select-Object @{N='resourceId'; E={$_.Id}} -ExpandProperty AppRoles | Select-Object resourceId, @{N='appRoleId'; E={$_.Id}}, @{N='displayName'; E={$_.Value}}
    $threatIntelServicePrincipal    = Get-MgServicePrincipal -Filter "appId eq '8ee8fdad-f234-4243-8f3b-15c294843740'" | Select-Object @{N='resourceId'; E={$_.Id}} -ExpandProperty AppRoles | Select-Object resourceId, @{N='appRoleId'; E={$_.Id}}, @{N='displayName'; E={$_.Value}}
} catch {
    Write-Message -icon "⛔️" -message "Something went wrong while retrieving Graph Service Principals :-( Error: $($_.Exception.Message)" -color3 "Red"
    Write-Host ""
    exit
}

# Loop through the managed identities
foreach($managedIdentity in $displayNameOfManagedIdentity) {
    Write-Message -type counter -countMax $displayNameOfManagedIdentity.Count -countMin ($displayNameOfManagedIdentity.IndexOf($managedIdentity) + 1) -message "Processing managed identity '$managedIdentity'..."
    Write-Host ""
    # Retrieve the service principal for the managed identity
    try {
        $servicePrincipal           = Get-MgServicePrincipal -Filter "DisplayName eq '$managedIdentity'"
        if($null -eq $servicePrincipal) {
            Write-Message -icon "🚫" -level 1 -message "Service principal for '$($managedIdentity)' not found!" -Color3 "Red"
            Write-Host ""
            continue
        }
    } catch {
        Write-Message -icon "⛔️" -level 1 -message "Something went wrong while looking up '$managedIdentity' :-( Error: $($_.Exception.Message)" -color3 "Red"
        Write-Host ""
    }

    # Microsoft Graph
    Write-Message -icon "🌩️ " -level 1 -message "Processing Microsoft Graph permissions..."
    foreach ($permissionDisplayName in $graphPermissions) {
        Write-Message -type item -level 2 -message "Assigning '$($permissionDisplayName)' to '$($managedIdentity)'..."
        # Collect appRoleId and resourceId for the permission
        $permission = $graphServicePrincipal | Where-Object { $_.DisplayName -eq $permissionDisplayName }
        if($null -eq $permission) {
            Write-Message -type item -level 3 -message "Permission '$($permissionDisplayName)' doesn't exist!" -color3 "Red"
            continue
        }
        # Check if permission is already assigned
        if($null -eq (Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id | Where-Object { $_.AppRoleId -eq $permission.appRoleId })) {
            $params = @{
                principalId = $servicePrincipal.Id
                resourceId  = $permission.resourceId
                appRoleId   = $permission.appRoleId
            }
            try {
                New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id -BodyParameter $params | Out-Null
                Write-Message -type item -level 3 -message "Permission assigned" -color3 "Green"
            } catch {
                Write-Message -type item -level 3 -message "Something went wrong :-( Error: $($_.Exception.Message)" -color3 "Red"
            }
        } else {
            Write-Message -type item -level 3 -message "Permission already assigned" -color3 "Yellow"
        }
    }
    Write-Host ""

    # WindowsDefenderATP
    Write-Message -icon "🛡️ " -level 1 -message "Processing Microsoft Threat Protection permissions..."
    foreach ($permissionDisplayName in $defenderPermissions) {
        Write-Message -type item -level 2 -message "Assigning '$($permissionDisplayName)' to '$($managedIdentity)'..."
        # Collect appRoleId and resourceId for the permission
        $permission = $defenderServicePrincipal | Where-Object { $_.DisplayName -eq $permissionDisplayName }
        if($null -eq $permission) {
            Write-Message -type item -level 3 -message "Permission '$($permissionDisplayName)' doesn't exist!" -color3 "Red"
            continue
        }
        # Check if permission is already assigned
        if($null -eq (Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id | Where-Object { $_.AppRoleId -eq $permission.appRoleId })) {
            $params = @{
                principalId = $servicePrincipal.Id
                resourceId  = $permission.resourceId
                appRoleId   = $permission.appRoleId
            }
            try {
                New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id -BodyParameter $params | Out-Null
                Write-Message -type item -level 3 -message "Permission assigned" -color3 "Green"
            } catch {
                Write-Message -type item -level 3 -message "Something went wrong :-( Error: $($_.Exception.Message)" -color3 "Red"
            }
        } else {
            Write-Message -type item -level 3 -message "Permission already assigned" -color3 "Yellow"
        }
    }
    Write-Host ""

    # Microsoft Threat Protection
    Write-Message -icon "🔎" -level 1 -message "Processing Microsoft Threat Protection permissions..."
    foreach ($permissionDisplayName in $threatIntelPermissions) {
        Write-Message -type item -level 2 -message "Assigning '$($permissionDisplayName)' to '$($managedIdentity)'..."
        # Collect appRoleId and resourceId for the permission
        $permission = $threatIntelServicePrincipal | Where-Object { $_.DisplayName -eq $permissionDisplayName }
        if($null -eq $permission) {
            Write-Message -type item -level 3 -message "Permission '$($permissionDisplayName)' doesn't exist!" -color3 "Red"
            continue
        }
        # Check if permission is already assigned
        if($null -eq (Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id | Where-Object { $_.AppRoleId -eq $permission.appRoleId })) {
            $params = @{
                principalId = $servicePrincipal.Id
                resourceId  = $permission.resourceId
                appRoleId   = $permission.appRoleId
            }
            try {
                New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipal.Id -BodyParameter $params | Out-Null
                Write-Message -type item -level 3 -message "Permission assigned" -color3 "Green"
            }
            catch {
                Write-Message -type item -level 3 -message "Something went wrong :-( Error: $($_.Exception.Message)" -color3 "Red"
            }
        } else {
            Write-Message -type item -level 3 -message "Permission already assigned" -color3 "Yellow"
        }
    }
    Write-Host ""
}

Write-Message -icon "🏁" -message "Finished!" -Color3 "Green"
Write-Host ""