task generate_latest_dockerfile {
    $path = Join-Path 'source' 'Files'
    New-DockerFileFromTemplate -WorkingDirectory $path
}

task connect_to_docker {
    Connect-Docker -Username 'scomnewbie' -Password 'coucou' #$env:PAT
}

task Read_env_variable {
    dir env:
}
