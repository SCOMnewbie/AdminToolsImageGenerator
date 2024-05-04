BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'
    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

InModuleScope 'AdminToolsImageGenerator' {
    Describe Get-LatestStableKubectlVersion {
        BeforeAll {
            Remove-Variable validinfo -ErrorAction SilentlyContinue
            $validinfo = Get-LatestStableKubectlVersion
        }

        Context 'Without extra parameters' {
            It 'Should not throw' {
                $validinfo | Should -not -BeNullOrEmpty
            }
    
            It 'Should be type of string' {
                $validinfo | Should -BeOfType -ExpectedType 'system.String'
            }
    
            It 'Should return a version' {
                # return v1.30.0
                { [System.Version]$($validinfo -replace 'v') } | Should -Not -Throw
            }
        }
    }
}

