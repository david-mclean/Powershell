# Thanks to Stackoverflow -> http://stackoverflow.com/questions/5648931/powershell-test-if-registry-value-exists
function Test-RegistryValue {
    param(
        [Alias("PSPath")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
        ,
        [Parameter(Position = 1, Mandatory = $true)]
        [String]$Name
        ,
        [Switch]$PassThru
    )

    process {
        if (Test-Path $Path) {
            $Key = Get-Item -LiteralPath $Path
            if ($Key.GetValue($Name, $null) -ne $null) {
                if ($PassThru) {
                    Get-ItemProperty $Path $Name
                } else {
                    $true
                }
            } else {
                $false
            }
        } else {
            $false
        }
    }
}

$netFourPath = "HKLM:\SOFTWARE\Microsoft\ASP.NET\4.0.30319.0"
$property = "EnableExtensionLessUrls"
$key = Get-Item $netFourPath

if(Test-RegistryValue $netFourPath $property){
	if($key.GetValue($property) -eq "0"){
		"Updated to 1 - EnableExtensionLessUrls is on"
		Set-ItemProperty $netFourPath -name $property -value "1"
	} else {
		"Updated to 0 - EnableExtensionLessUrls is off"
		Set-ItemProperty $netFourPath -name $property -value "0"
	}
} else {
	"Updated to 0 - EnableExtensionLessUrls is off"
	New-ItemProperty $netFourPath -name $property -value "0" -propertyType dword
}