<#
Compila sin guardar tu clave ni rutas personales en el repositorio.
SdkPath es la carpeta del SDK que contiene bin/monkeyc.bat.
KeyPath apunta a tu clave privada, preferiblemente fuera de este proyecto.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$SdkPath,
    [Parameter(Mandatory = $true)][string]$KeyPath,
    [string]$JavaHome
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$compiler = Join-Path $SdkPath 'bin/monkeyc.bat'
if (!(Test-Path -LiteralPath $compiler -PathType Leaf)) {
    throw 'No se encuentra bin/monkeyc.bat dentro del SDK indicado.'
}
if (!(Test-Path -LiteralPath $KeyPath -PathType Leaf)) {
    throw 'No se encuentra la clave privada indicada.'
}
$originalPath = $env:Path
try {
    if ($JavaHome) {
        $javaBin = Join-Path $JavaHome 'bin'
        if (!(Test-Path -LiteralPath (Join-Path $javaBin 'java.exe'))) {
            throw 'JavaHome debe ser la carpeta de Java que contiene bin/java.exe.'
        }
        $env:Path = $javaBin + [IO.Path]::PathSeparator + $env:Path
    }
    if (!(Get-Command java -ErrorAction SilentlyContinue)) {
        throw 'Instala Java o indica su carpeta mediante -JavaHome.'
    }
    $outputDir = Join-Path $projectRoot 'bin'
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    & $compiler --build-stats 0 -f (Join-Path $projectRoot 'monkey.jungle') -d fr55 -o (Join-Path $outputDir 'GymApp.prg') -y $KeyPath
    if ($LASTEXITCODE -ne 0) { throw 'La compilacion ha fallado. Revisa los mensajes anteriores.' }
    Write-Host 'Compilacion correcta: bin/GymApp.prg'
} finally {
    $env:Path = $originalPath
}
