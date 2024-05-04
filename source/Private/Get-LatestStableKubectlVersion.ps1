Function Get-LatestStableKubectlVersion {
    <#
    .SYNOPSIS

    Return the latest stable version of Kubectl.

    .DESCRIPTION

    Return the latest stable version of Kubectl.

    .PARAMETER Product
    Specify the product you're interrested in.

    .EXAMPLE
    PS> Get-LatestStableKubectlVersion
    #>
    [CmdletBinding()]
    Param(
        $Url = 'https://dl.k8s.io/release/stable.txt'
    )

    Write-Verbose "[$((Get-Date).TimeOfDay)] Url is: $Url"
    $LatestVersion = Invoke-RestMethod -Uri $Url
    $ErrorActionPreferenceTEMP = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {
        [System.Version]$($LatestVersion -replace 'v') | Out-Null
        Write-Verbose "[$((Get-Date).TimeOfDay)] Kubectl latest version is: $LatestVersion"
        return $LatestVersion
    }
    catch {
        return $null
    }
    finally {
        $ErrorActionPreference = $ErrorActionPreferenceTEMP
    }
}