# Synergy UI Rebranding Script
# Simple but effective bulk replacement
$repoPath = Get-Location
Write-Host "Rebranding from open-webui to Synergy UI..." -ForegroundColor Cyan

$replacements = @(
    @{ old = "open-webui"; new = "synergy-ui" },
    @{ old = "openwebui"; new = "synergyui" },
    @{ old = "Open WebUI"; new = "Synergy UI" },
    @{ old = "Open-WebUI"; new = "Synergy-UI" },
    @{ old = "OPEN_WEBUI"; new = "SYNERGY_UI" },
    @{ old = "open_webui"; new = "synergy_ui" },
    @{ old = "tim@openwebui.com"; new = "info@synergyui.com" },
    @{ old = "openwebui.com"; new = "synergyui.com" }
)

$filePatterns = "*.json", "*.toml", "*.yaml", "*.yml", "*.md", "*.ts", "*.js", "*.py", "*.sh", "*.css", "*.html", "*.svelte", "*.xml", "Dockerfile*", "Makefile", "*.lock", "LICENSE*", "README*", "CHANGELOG*"
$excludeDirs = "node_modules", ".git", ".venv", "venv", "__pycache__", "cypress", "dist", ".svelte-kit"

$files = @()
foreach ($pattern in $filePatterns) {
    $files += Get-ChildItem -Path $repoPath -Recurse -Include $pattern -File -ErrorAction SilentlyContinue
}

$files = $files | Where-Object { 
    $exclude = $false
    foreach ($dir in $excludeDirs) {
        if ($_.FullName -like "*\$dir\*") { $exclude = $true }
    }
    -not $exclude
} | Select-Object -Unique

Write-Host "Found $($files.Count) files to process`n"

$totalChanges = 0
$filesChanged = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }
    
    $original = $content
    
    foreach ($replacement in $replacements) {
        $content = $content -replace [regex]::Escape($replacement.old), $replacement.new
    }
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $filesChanged++
        $changes = 0
        foreach ($rep in $replacements) {
            $changes += ($original -split [regex]::Escape($rep.old)).Count - 1
        }
        $totalChanges += $changes
        $rel = $file.FullName -replace [regex]::Escape($repoPath), "."
        Write-Host "✓ $rel ($changes changes)"
    }
}

Write-Host "`n✅ Complete! Modified $filesChanged files with $totalChanges total replacements"
