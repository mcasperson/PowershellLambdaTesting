<#
.SYNOPSIS
Attempts to clear the /tmp directory when run from Linux
#>
function Clear-Tmp {
    if ($IsLinux)
    {
        try
        {
            Remove-Item -Recurse -Path "/tmp/*"
        }
        catch
        {
            # Ignore
        }
    }
}

function New-LambdaTemporaryDirectory {
    $dir = "/tmp/$([guid]::NewGuid().ToString())"
    mkdir $dir | Out-Null
    return $dir
}

function New-GeneralTemporaryDirectory {
    $dir = New-TemporaryFile
    Remove-Item $dir | Out-Null
    mkdir $dir | Out-Null
    return $dir.ToString()
}

function New-TemporaryDirectory {
    if ($IsLinux) {
        return New-LambdaTemporaryDirectory
    }

    return New-GeneralTemporaryDirectory
}

function Expand-Archive
{
    param (
        [string]$zipfile,
        [string]$outpath
    )

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function Expand-RemoteArchive {
    param (
        [string]$tempDir,
        [string]$url,
        [string]$executableName = $null
    )

    $ProgressPreference = 'SilentlyContinue'

    $tmpFile = "$tempDir/$([guid]::NewGuid().ToString()).zip"
    Invoke-WebRequest -Uri $url -OutFile $tmpFile
    Expand-Archive $tmpFile $tempDir

    if ($executableName -ne $null) {
        if ($IsLinux)
        {
            chmod +x "$tempDir/$executableName"
        }
    }

    Remove-Item $tmpFile
}

function Enable-TLS12 {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}