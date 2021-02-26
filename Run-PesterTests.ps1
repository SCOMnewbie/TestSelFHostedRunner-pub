import-module pester -MinimumVersion 5.1
$configuration = [PesterConfiguration]::Default
$configuration.TestResult.OutputFormat = 'NUnitXml'
$configuration.TestResult.Enabled = $true
$configuration.Run.Exit = $true
Invoke-Pester -configuration $configuration