BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

InModuleScope 'AdminToolsImageGenerator' {
    Describe Get-LatestGithubRepositoryReleaseVersion {
        BeforeAll {
            Remove-Variable validinfo -ErrorAction SilentlyContinue
            $validinfo = Get-LatestGithubRepositoryReleaseVersion -OrganizationName aquasecurity -RepositoryName trivy
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
            It 'Should return null' {
                { Get-LatestGithubRepositoryReleaseVersion -OrganizationName 'dummyorg543' -RepositoryName 'dummyrepo346' } | Should -Throw -ExpectedMessage "Response status code does not indicate success: 404 (Not Found)."
            }
        }
    }
}

