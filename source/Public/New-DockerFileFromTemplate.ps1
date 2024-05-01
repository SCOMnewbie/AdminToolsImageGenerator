function New-DockerFileFromTemplate {
    param(
        [string]$WorkingDirectory
    )

    $VerbosePreference = 'Continue'
    $ErrorActionPreference = 'Stop'

    # declare paths
    $global:WorkingDirectory = $WorkingDirectory
    #$global:ScriptsPath = Join-Path $WorkingDirectory scripts

    # Let's fetch the tools we want to update based on the DockerFile Template

    $Regex = '<_(?<ToolToUpdate>.*_.*)_LatestStableVersion_>' #Regex related to the convention used
    $DockerFileTemplate = Get-Content -Path $(Join-Path $WorkingDirectory Dockerfile_Template)

    if(Test-Path $(Join-Path $WorkingDirectory Dockerfile)){
        Write-Verbose "[$((Get-Date).TimeOfDay)] Clean previously created Dockerfile"
        Remove-Item $(Join-Path $WorkingDirectory Dockerfile) -Force
    }
    # String manipulation that will output the various tools to update in the Docker image like:
    # Hashicorp_Terraform
    # Hashicorp_Vault
    # Github_project-copacetic/Copacetic
    # Github_aquasecurity/Trivy
    $ToolsToUpdate = $DockerFileTemplate | select-string -Pattern $Regex | % Matches | % Groups | Group-Object -Property Name | where Name -eq 'ToolToUpdate' | % Group | % Value

    Write-Verbose "[$((Get-Date).TimeOfDay)] Number of tools to update: $($ToolsToUpdate.count)"

    Foreach ($ToolToUpdate in $ToolsToUpdate) {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Working on tool: $ToolToUpdate"
        switch -Wildcard ($ToolToUpdate) {
            'Hashicorp_*' {
                Write-Verbose "[$((Get-Date).TimeOfDay)] Hashicorp tool detected Let's fetch latest stable version"
                $Product = $ToolToUpdate | Select-String -Pattern '^Hashicorp_(?<product>.*)$' | % Matches | % Groups | where Name -eq 'product' | % value
                Write-Verbose "[$((Get-Date).TimeOfDay)] Product detected: $Product"
                $LatestStableVersion = Get-LatestStableHashicorpProductVersion -Product $Product

                # if DockerFile exist use it else use template
                if (Test-Path $(Join-Path $WorkingDirectory 'Dockerfile')) {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] Dockerfile exist, let's update it"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile)
                    $TempFile = $TempFile -replace "<_Hashicorp_$($Product)_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    #Write-Verbose "[$((Get-Date).TimeOfDay)] DockerFile has been updated for Hashicorp $Product with version $LatestStableVersion"
                    Write-Output $($psstyle.Background.BrightMagenta)" DockerFile has been updated for Hashicorp $Product with version $LatestStableVersion "$($psstyle.Reset)
                }
                else {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] No Dockerfile detected, let's create a new one"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile_Template)
                    $TempFile = $TempFile -replace "<_Hashicorp_$($Product)_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    #Write-Verbose "[$((Get-Date).TimeOfDay)] DockerFile has been created for Hashicorp $Product with version $LatestStableVersion"
                    Write-Output $($psstyle.Background.Magenta)" DockerFile has been created for Hashicorp $Product with version $LatestStableVersion "$($psstyle.Reset)
                }
                break
            }
            'Github_*' {
                Write-Verbose "[$((Get-Date).TimeOfDay)] Github tool detected Let's fetch latest stable version"
                $GHOrganization = $ToolToUpdate | Select-String -Pattern '^Github_(?<GHOrganization>.*)\/(?<GHRepository>.*)$' | % Matches | % Groups | where Name -eq 'GHOrganization' | % value
                Write-Verbose "[$((Get-Date).TimeOfDay)] Github Organization detected: $GHOrganization"
                $GHRepository = $ToolToUpdate | Select-String -Pattern '^Github_(?<GHOrganization>.*)\/(?<GHRepository>.*)$' | % Matches | % Groups | where Name -eq 'GHRepository' | % value
                Write-Verbose "[$((Get-Date).TimeOfDay)] Github Repository detected: $GHRepository"
                $LatestStableVersion = Get-LatestGithubRepositoryReleaseVersion -OrganizationName $GHOrganization -RepositoryName $GHRepository
                # if DockerFile exist use it else use template
                if (Test-Path $(Join-Path $WorkingDirectory 'Dockerfile')) {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] Dockerfile exist, let's update it"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile)
                    $TempFile = $TempFile -replace "<_Github_$($GHOrganization)/$($GHRepository)_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    #Write-Verbose "[$((Get-Date).TimeOfDay)] DockerFile has been updated for Github project $GHOrganization/$GHRepository with version $LatestStableVersion"
                    Write-Output $($psstyle.Background.BrightMagenta)" DockerFile has been updated for Github project $GHOrganization/$GHRepository with version $LatestStableVersion "$($psstyle.Reset)
                }
                else {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] No Dockerfile detected, let's create a new one"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile_Template)
                    $TempFile = $TempFile -replace "<_Github_$($GHOrganization)/$($GHRepository)_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    #Write-Verbose "[$((Get-Date).TimeOfDay)] DockerFile has been created for Github project $GHOrganization/$GHRepository with version $LatestStableVersion"
                    Write-Output $($psstyle.Background.Magenta)" DockerFile has been created for Github project $GHOrganization/$GHRepository with version $LatestStableVersion "$($psstyle.Reset)
                }
                break
            }
            'Kubernetes_*' {
                Write-Verbose "[$((Get-Date).TimeOfDay)] Kubernetes tool detected Let's fetch latest stable version"
                $LatestStableVersion = Get-LatestStableKubectlVersion
                # if DockerFile exist use it else use template
                if (Test-Path $(Join-Path $WorkingDirectory 'Dockerfile')) {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] Dockerfile exist, let's update it"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile)
                    $TempFile = $TempFile -replace "<_Kubernetes_kubectl_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    Write-Output $($psstyle.Background.BrightMagenta)" DockerFile has been updated for Kubectl version with version $LatestStableVersion "$($psstyle.Reset)
                }
                else {
                    Write-Verbose "[$((Get-Date).TimeOfDay)] No Dockerfile detected, let's create a new one"
                    $TempFile = Get-Content $(Join-Path $WorkingDirectory Dockerfile_Template)
                    $TempFile = $TempFile -replace "<_Kubernetes_kubectl_LatestStableVersion_>", $LatestStableVersion
                    Set-Content -Path $(Join-Path $WorkingDirectory 'Dockerfile') -Value $TempFile
                    Write-Output $($psstyle.Background.Magenta)" DockerFile has been created for Kubectl version with version $LatestStableVersion "$($psstyle.Reset)
                }
                break
            }
            Default { Write-Output $($psstyle.Background.BrightRed)" Tool not currently supported to be updated "$($psstyle.Reset) }
        }
    }
}