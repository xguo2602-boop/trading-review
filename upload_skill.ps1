# upload_skill.ps1：提交并推送 skill 规则到 GitHub（自动备份，公开仓库）
# 用法：直接运行；凭据由 git credential.helper 提供（token 存 LOCALAPPDATA\git-credentials，不进仓库）
# 只推送规则文件（SKILL.md/references/.gitignore），数据文件被 .gitignore 排除
$ErrorActionPreference = 'Stop'
$git = Join-Path $env:LOCALAPPDATA 'Programs\MinGit\cmd\git.exe'
$skill = 'C:\Users\86131\.codex\skills\trading-review'
Set-Location $skill

& $git add SKILL.md references .gitignore upload_skill.ps1
if (& $git diff --cached --quiet) {
    Write-Output ('[' + (Get-Date -Format 'HH:mm') + '] 无规则变更，跳过提交')
} else {
    & $git commit -m ('skill 规则更新 ' + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
}
& $git push
Write-Output '已推送 GitHub'
