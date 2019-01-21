#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

Export-ModuleMember -Function Clear-Tmp
Export-ModuleMember -Function Expand-RemoteArchive
Export-ModuleMember -Function New-TemporaryDirectory
Export-ModuleMember -Function New-KubeConfig
Export-ModuleMember -Function Enable-TLS12
Export-ModuleMember -Function Get-HostedTenants