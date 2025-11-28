# Set Execution Policy, enable TLS 1.2, and install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Configure Chocolatey and install software
choco feature enable -n allowGlobalConfirmation
choco install vscode -y

# Set Execution Policy for current process
Set-ExecutionPolicy Bypass -Scope Process

# Disable Windows Defender 
Set-MpPreference -DisableRealtimeMonitoring $true

# Uninstall Windows Defender (if available)
try {
    Remove-WindowsFeature Windows-Defender -ErrorAction Stop
} catch {
    Write-Warning "Windows Defender feature removal failed or not available: $_"
}

# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Enable IIS options
$featuresToEnable = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-HttpErrors",
    "IIS-HttpRedirect",
    "IIS-ApplicationDevelopment",
    "NetFx4Extended-ASPNET45",
    "IIS-NetFxExtensibility45",
    "IIS-HealthAndDiagnostics",
    "IIS-HttpLogging",
    "IIS-LoggingLibraries",
    "IIS-RequestMonitor",
    "IIS-HttpTracing",
    "IIS-Security",
    "IIS-RequestFiltering",
    "IIS-WebServerManagementTools",
    "IIS-ManagementConsole",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-ISAPIExtensions",
    "IIS-ISAPIFilter",
    "IIS-ASPNET45",
    "IIS-CGI",
    "IIS-ManagementScriptingTools"
)

foreach ($feature in $featuresToEnable) {
    try {
        Enable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
        Write-Host "Enabled feature: $feature"
    } catch {
        Write-Warning "Failed to enable feature $feature : $_"
    }
}

# Disable IIS authentication features
$featuresToDisable = @(
    "IIS-BasicAuthentication",
    "IIS-WindowsAuthentication"
)

foreach ($feature in $featuresToDisable) {
    try {
        Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
        Write-Host "Disabled feature: $feature"
    } catch {
        Write-Warning "Failed to disable feature $feature : $_"
    }
}

# Install SQL Server Express 2019
function Install-SQLServerExpress2019 {
    Write-Host "Downloading SQL Server Express 2019..."
    $Path = $env:TEMP
    $Installer = "SQL2019-SSEI-Expr.exe"
    $URL = "https://go.microsoft.com/fwlink/?linkid=866658"
    
    try {
        Invoke-WebRequest $URL -OutFile "$Path\$Installer"
        
        Write-Host "Installing SQL Server Express..."
        $process = Start-Process -FilePath "$Path\$Installer" -Args "/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /QUIET" -Verb RunAs -PassThru -Wait
        
        if ($process.ExitCode -eq 0) {
            Write-Host "SQL Server Express installed successfully"
        } else {
            Write-Warning "SQL Server Express installation completed with exit code: $($process.ExitCode)"
        }
        
    } catch {
        Write-Error "Failed to install SQL Server Express: $_"
    } finally {
        if (Test-Path "$Path\$Installer") {
            Remove-Item "$Path\$Installer" -Force
        }
    }
}

Install-SQLServerExpress2019

Write-Host "Script execution completed."
