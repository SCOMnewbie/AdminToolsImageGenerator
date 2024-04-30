task generate_latest_dockerfile {
    $path = Join-Path 'source' 'Files'
    New-DockerFileFromTemplate -WorkingDirectory $path
}

task connect_to_docker {
    Connect-Docker -Username 'scomnewbie' -Password $env:PAT
}

task docker_build {
    $path = Join-Path 'source' 'Files'
    cd $path
    docker build -t admintools:latest .
}

task docker_tag {
    docker tag admintools:latest ghcr.io/scomnewbie/admintools:latest
}

task docker_push {
    docker push ghcr.io/scomnewbie/admintools:latest
}