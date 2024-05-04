task generate_latest_dockerfile {
    $path = Join-Path 'source' 'Files'
    New-DockerFileFromTemplate -WorkingDirectory $path
    if(0 -ne $LASTEXITCODE){exit 1}
}

task connect_to_docker {
    Connect-Docker -Username 'scomnewbie' -Password $env:PAT
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_build {
    $path = Join-Path 'source' 'Files'
    cd $path
    docker build -t admintools:latest .
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_tag {
    docker tag admintools:latest ghcr.io/scomnewbie/admintools:latest
    if(0 -ne $LASTEXITCODE){exit 1}
}

task docker_push {
    docker push ghcr.io/scomnewbie/admintools:latest
    if(0 -ne $LASTEXITCODE){exit 1}
}