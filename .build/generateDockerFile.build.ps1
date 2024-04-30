task generate_latest_dockerfile {
    $path = Join-Path 'source' 'Files'
    New-DockerFileFromTemplate -WorkingDirectory $path
}

task connect_to_docker {
    Connect-Docker -Username 'scomnewbie' -Password $env:Docker
}

task Read_env_variable {
    dir env:
}

task ghcr_login {
    git config --global credential.helper store
}
