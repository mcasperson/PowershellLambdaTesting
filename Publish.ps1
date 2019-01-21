$PublishParams = @{
    Path = "$(Get-Location)\PowershellLambdaTesting"
    NuGetApiKey = $env:PowershellGalleryApiKey
}

# There is no way to exclude files, so move the files were are interested in to a temporary location
If (Test-Path PowershellLambdaTesting){
    Remove-Item -Recurse PowershellLambdaTesting
}
mkdir PowershellLambdaTesting
mkdir PowershellLambdaTesting/Public
cp PowershellLambdaTesting.psd1 PowershellLambdaTesting
cp PowershellLambdaTesting.psm1 PowershellLambdaTesting
cp Public/Utils.ps1 PowershellLambdaTesting/Public
cp Public/Kubernetes.ps1 PowershellLambdaTesting/Public

# Publish the module
Publish-Module @PublishParams

# Clear the temporary files
Remove-Item -Recurse PowershellLambdaTesting