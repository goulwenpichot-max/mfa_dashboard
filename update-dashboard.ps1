$RepoPath = "C:\Users\g.pichotdechampfleur\.claude\Dataviz_MFA\mfa_dashboard"
$CurrentDashboard = "$RepoPath\dashboard.html"
$LogFile = "$RepoPath\update.log"

# Prendre le fichier HTML le plus récent dans Downloads (hors dashboard déjà publié)
$Latest = Get-ChildItem "$env:USERPROFILE\Downloads\*.html" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $Latest) {
    exit 0
}

# Comparer avec la version actuelle — ne rien faire si déjà à jour
if ((Test-Path $CurrentDashboard)) {
    $CurrentDate = (Get-Item $CurrentDashboard).LastWriteTime
    if ($Latest.LastWriteTime -le $CurrentDate) {
        exit 0
    }
}

Copy-Item $Latest.FullName $CurrentDashboard -Force

Set-Location $RepoPath
git add dashboard.html
git commit -m "Update dashboard $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
git push

$msg = "$(Get-Date -Format 'dd/MM/yyyy HH:mm') - Publié : $($Latest.Name)"
Add-Content $LogFile $msg
Write-Host $msg
