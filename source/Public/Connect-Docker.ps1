function Connect-Docker {
    param (
        [Parameter(Mandatory)]
        [string]$Username,
        [Parameter(Mandatory)]
        [string]$Password,
        [string]$Server = 'https://ghcr.io'
    )
    
    docker login $Server -u $Username -p $Password  
}

