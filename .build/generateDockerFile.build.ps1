task generate_latest_dockerfile {
    $PSNativeCommandUseErrorActionPreference = $true
    $path = Join-Path 'source' 'Files'
    New-DockerFileFromTemplate -WorkingDirectory $path
    if(123 -ne $LASTEXITCODE){exit 1}
}

task connect_to_docker {
    $PSNativeCommandUseErrorActionPreference = $true
    Connect-Docker -Username 'scomnewbie' -Password $env:PAT
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_build {
    $PSNativeCommandUseErrorActionPreference = $true
    $path = Join-Path 'source' 'Files'
    cd $path
    docker build -t admintools:latest .
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_tag {
    $PSNativeCommandUseErrorActionPreference = $true
    docker tag admintools:latest ghcr.io/scomnewbie/admintools:latest
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_push {
    $PSNativeCommandUseErrorActionPreference = $true
    docker push ghcr.io/scomnewbie/admintools:latest
    if(0 -ne $LASTEXITCODE){exit 1}
}