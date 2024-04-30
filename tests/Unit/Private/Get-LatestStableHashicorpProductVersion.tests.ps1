BeforeAll {
    $script:dscModuleName = 'AdminToolsImageGenerator'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-LatestStableHashicorpProductVersion {
   # BeforeAll {
   #     Mock -CommandName Get-PrivateFunction -MockWith {
   #         # This return the value passed to the Get-PrivateFunction parameter $PrivateData.
   #         $PrivateData
   #     } -ModuleName $dscModuleName
   # }


    Context 'True should be true' {
        It 'True should be true' {
            $true | Should -Be $true
        }
    }
}

