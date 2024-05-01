BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-LatestStableKubectlVersion {

    Context 'True should be true' {
        It 'True should be true' {
            $true | Should -Be $true
        }
    }
}

