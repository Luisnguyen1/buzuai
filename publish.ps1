# publish.ps1 - Script tự động build và publish buzuai package

param(
    [switch]$test,  # Publish lên TestPyPI
    [switch]$prod,  # Publish lên PyPI
    [switch]$clean  # Chỉ clean
)

# Colors
$ColorInfo = "Cyan"
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"

function Write-Step {
    param([string]$Message)
    Write-Host "`n$Message" -ForegroundColor $ColorInfo
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $ColorSuccess
}

function Write-Warn {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $ColorWarning
}

function Write-Err {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $ColorError
}

# Banner
Write-Host @"

╔═══════════════════════════════════════╗
║   🚀 BuzuAI Package Publisher 🚀     ║
╚═══════════════════════════════════════╝

"@ -ForegroundColor $ColorInfo

# Clean
Write-Step "🧹 Cleaning old builds..."
$itemsToRemove = @("dist", "build", "buzuai.egg-info", "buzuai/__pycache__")
foreach ($item in $itemsToRemove) {
    if (Test-Path $item) {
        Remove-Item -Recurse -Force $item
        Write-Host "  Removed: $item" -ForegroundColor Gray
    }
}
Write-Success "Clean completed!"

if ($clean) {
    Write-Host "`n✨ Clean only - Done!`n" -ForegroundColor $ColorSuccess
    exit 0
}

# Check required files
Write-Step "📋 Checking required files..."
$requiredFiles = @(
    "buzuai/__init__.py",
    "buzuai/client.py",
    "setup.py",
    "pyproject.toml",
    "README.md",
    "LICENSE"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Gray
    } else {
        Write-Err "Missing: $file"
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Err "Some required files are missing!"
    exit 1
}
Write-Success "All required files present!"

# Get version
Write-Step "🔍 Detecting version..."
$versionLine = Select-String -Path "pyproject.toml" -Pattern 'version = "(.+)"'
if ($versionLine) {
    $version = $versionLine.Matches[0].Groups[1].Value
    Write-Host "  Version: $version" -ForegroundColor $ColorSuccess
} else {
    Write-Err "Cannot detect version from pyproject.toml"
    exit 1
}

# Build
Write-Step "🏗️  Building package..."
Write-Host "  Running: python -m build" -ForegroundColor Gray

python -m build 2>&1 | ForEach-Object {
    Write-Host "  $_" -ForegroundColor DarkGray
}

if ($LASTEXITCODE -ne 0) {
    Write-Err "Build failed! Error code: $LASTEXITCODE"
    exit 1
}
Write-Success "Build completed!"

# Check dist files
Write-Step "📦 Built files:"
if (Test-Path "dist") {
    Get-ChildItem dist | ForEach-Object {
        $size = [math]::Round($_.Length / 1KB, 2)
        Write-Host "  📄 $($_.Name) ($size KB)" -ForegroundColor White
    }
} else {
    Write-Err "dist/ folder not found!"
    exit 1
}

# Check package
Write-Step "🔍 Checking package integrity..."
python -m twine check dist/* 2>&1 | ForEach-Object {
    if ($_ -match "PASSED") {
        Write-Host "  $_" -ForegroundColor $ColorSuccess
    } else {
        Write-Host "  $_" -ForegroundColor Gray
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Err "Package check failed!"
    exit 1
}
Write-Success "Package check passed!"

# Upload
if ($test) {
    Write-Step "📤 Uploading to TestPyPI..."
    Write-Host "  Repository: https://test.pypi.org/" -ForegroundColor Gray
    Write-Host "  Version: $version" -ForegroundColor Gray
    Write-Host ""
    
    python -m twine upload --repository testpypi dist/*
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Successfully uploaded to TestPyPI!"
        Write-Host ""
        Write-Host "  View at: https://test.pypi.org/project/buzuai/$version/" -ForegroundColor $ColorInfo
        Write-Host ""
        Write-Host "  To install:" -ForegroundColor $ColorInfo
        Write-Host "  pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ buzuai" -ForegroundColor White
    } else {
        Write-Err "Upload to TestPyPI failed!"
        exit 1
    }
    
} elseif ($prod) {
    Write-Warn "You are about to upload to PRODUCTION PyPI!"
    Write-Host "  Repository: https://pypi.org/" -ForegroundColor Gray
    Write-Host "  Package: buzuai" -ForegroundColor Gray
    Write-Host "  Version: $version" -ForegroundColor Gray
    Write-Host ""
    Write-Warn "This action CANNOT be undone!"
    Write-Host ""
    Write-Host "Press Ctrl+C to cancel, or any key to continue..." -ForegroundColor $ColorWarning
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    Write-Step "📤 Uploading to PyPI..."
    python -m twine upload dist/*
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Success "🎉 Successfully published to PyPI!"
        Write-Host ""
        Write-Host "  View at: https://pypi.org/project/buzuai/$version/" -ForegroundColor $ColorInfo
        Write-Host ""
        Write-Host "  To install:" -ForegroundColor $ColorInfo
        Write-Host "  pip install buzuai" -ForegroundColor White
        Write-Host ""
        Write-Host "  To upgrade:" -ForegroundColor $ColorInfo
        Write-Host "  pip install --upgrade buzuai" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Err "Upload to PyPI failed!"
        exit 1
    }
    
} else {
    Write-Host ""
    Write-Success "Package built successfully!"
    Write-Host ""
    Write-Host "📤 To upload:" -ForegroundColor $ColorInfo
    Write-Host "  Test (TestPyPI):  " -NoNewline -ForegroundColor Gray
    Write-Host ".\publish.ps1 -test" -ForegroundColor White
    Write-Host "  Production (PyPI):" -NoNewline -ForegroundColor Gray
    Write-Host ".\publish.ps1 -prod" -ForegroundColor White
    Write-Host ""
    Write-Host "🧹 To clean only:    " -NoNewline -ForegroundColor Gray
    Write-Host ".\publish.ps1 -clean" -ForegroundColor White
    Write-Host ""
}

Write-Host "✨ Done!`n" -ForegroundColor $ColorSuccess