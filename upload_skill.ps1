# upload_skill.ps1 - commit & push skill rules to GitHub (public repo)
# Trigger: run manually after rules change; only commits/pushes when there are changes.
# Credentials come from git credential.helper (token stored in %LOCALAPPDATA%\git-credentials, not in repo).
# ASCII-only on purpose: PowerShell 5.1 reads UTF-8-no-BOM files as GBK, corrupting Chinese literals.
$ErrorActionPreference = 'Stop'
$git = Join-Path $env:LOCALAPPDATA 'Programs\MinGit\cmd\git.exe'
$skill = 'C:\Users\86131\.codex\skills\trading-review'
Set-Location $skill

& $git add SKILL.md references .gitignore upload_skill.ps1
if (& $git diff --cached --quiet) {
    Write-Output ('[' + (Get-Date -Format 'HH:mm') + '] No rule changes, skip commit & push')
} else {
    & $git commit -m ('skill rules update ' + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
}
$unpushed = & $git rev-list --count '@{u}..HEAD' 2>$null
if ($unpushed -and $unpushed -ne '0') {
    & $git push
    Write-Output 'Pushed to GitHub'
} else {
    Write-Output 'No unpushed commits, skip push'
}
