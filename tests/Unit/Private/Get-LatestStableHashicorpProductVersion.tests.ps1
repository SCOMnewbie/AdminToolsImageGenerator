BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

InModuleScope 'AdminToolsImageGenerator' {
    Describe Get-LatestStableHashicorpProductVersion {
        BeforeAll {
            Remove-Variable validinfo -ErrorAction SilentlyContinue
            $validinfo = Get-LatestStableHashicorpProductVersion -Product vault
        }
    
        Context 'With Valid values' {
            It 'Should not throw' {
                $validinfo | Should -not -BeNullOrEmpty
            }
    
            It 'Should be type of string' {
                $validinfo | Should -BeOfType -ExpectedType 'system.String'
            }
    
            It 'Should return a version' {
                { [System.Version]$validinfo } | Should -Not -Throw
            }
        }
    
        Context 'With Wrong values' {
            It 'Should throw' {
                { Get-LatestStableHashicorpProductVersion -Product wrong } | Should -Throw
            }
        }
    }
}


