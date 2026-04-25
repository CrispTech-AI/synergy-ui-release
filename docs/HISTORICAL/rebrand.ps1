#!/usr/bin/env pwsh
# Synergy UI Rebranding Script

$repoPath = Get-Location
Write-Host "Starting rebranding from open-webui to Synergy UI..." -ForegroundColor Cyan

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
        if ($_.FullName -like "*\$dir\*") { 
            $exclude = $true 
        }
    }
    -not $exclude
} | Select-Object -Unique

Write-Host "Found $($files.Count) files to process`n" -ForegroundColor Yellow

$totalChanges = 0
$filesChanged = 0

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $content) { 
            continue 
        }
        
        $original = $content
        
        foreach ($replacement in $replacements) {
            $content = $content -replace [regex]::Escape($replacement.old), $replacement.new
        }
        
        if ($content -ne $original) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $filesChanged += 1
            $changes = 0
            foreach ($rep in $replacements) {
                $changes += ($original -split [regex]::Escape($rep.old)).Count - 1
            }
            $totalChanges += $changes
            $rel = $file.FullName -replace [regex]::Escape($repoPath), "."
            Write-Host "[OK] $rel ($changes changes)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[ERROR] $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Rebranding Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Files Modified: $filesChanged" -ForegroundColor Yellow
Write-Host "Total Replacements: $totalChanges" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Replace graphics/assets in static/assets/" -ForegroundColor White
Write-Host "2. Update static/manifest.json PWA metadata" -ForegroundColor White
Write-Host "3. Review README.md and key config files" -ForegroundColor White
Write-Host "4. Test build: npm run build" -ForegroundColor White
Write-Host ""
