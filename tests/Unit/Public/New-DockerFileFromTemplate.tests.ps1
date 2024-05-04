BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'
    Import-Module -Name $script:dscModuleName
    $script:module = Split-Path -Path  $(Get-module -Name $script:dscModuleName).Path -Parent
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe New-DockerFileFromTemplate {
    BeforeAll {
        Remove-Variable DockerFile -ErrorAction SilentlyContinue
        $DockerFileTemplate = Get-Item -Path $(Join-Path $module Files Dockerfile_Template)
        $DockerFileTemplateContent = Get-Content -Path $(Join-Path $module Files Dockerfile_Template)

        #Remove pre existing generated Dockerfile
        Remove-Item -Path $(Join-Path $module Files Dockerfile) -Force -ErrorAction SilentlyContinue
        # Generate new dockerfile
        New-DockerFileFromTemplate -WorkingDirectory $(Join-Path $module Files)
        $DockerFile = Get-Item -Path $(Join-Path $module Files Dockerfile)
        $DockerFileContent = Get-Content -Path $(Join-Path $module Files Dockerfile)
    }

    Context 'Dockerfile Template' {
        It 'Should exist' {
            $DockerFileTemplate | Should -Exist
        }

        It 'Should not be null' {
            $DockerFileTemplateContent | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Dockerfile' {
        It 'Should exist' {
            $DockerFile | Should -Exist
        }

        It 'Should not be null' {
            $DockerFileContent | Should -Not -BeNullOrEmpty
        }
    }
}