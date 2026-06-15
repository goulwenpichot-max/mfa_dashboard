param(
    [string]$FilePath
)

$RepoPath = "C:\Users\g.pichotdechampfleur\.claude\Dataviz_MFA\mfa_dashboard"

# Si aucun fichier fourni, prendre le plus récent fichier HTML du dossier Downloads
if (-not $FilePath) {
    $FilePath = Get-ChildItem "$env:USERPROFILE\Downloads\*.html" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1 -ExpandProperty FullName

    if (-not $FilePath) {
        Write-Error "Aucun fichier HTML trouvé dans Downloads."
        exit 1
    }
    Write-Host "Fichier détecté : $FilePath"
}

if (-not (Test-Path $FilePath)) {
    Write-Error "Fichier introuvable : $FilePath"
    exit 1
}

Copy-Item $FilePath "$RepoPath\dashboard.html" -Force

Set-Location $RepoPath
git add dashboard.html
git commit -m "Update dashboard $(Get-Date -Format 'dd/MM/yyyy')"
git push

Write-Host ""
Write-Host "Dashboard mis a jour : https://goulwenpichot-max.github.io/mfa_dashboard/dashboard.html"
