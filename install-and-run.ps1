# SHOPPUS - Install and Run Script
# Run this in PowerShell if npm install fails due to path/permission issues.
# Optionally run as Administrator: Right-click PowerShell -> Run as administrator

$ErrorActionPreference = "Stop"
$projectPath = "c:\Users\MODAdministrator\Downloads\ecommerce-cursor"

Write-Host "Cleaning previous install..." -ForegroundColor Cyan
Set-Location $projectPath
if (Test-Path node_modules) { 
    Remove-Item -Recurse -Force node_modules 
    Write-Host "Removed node_modules" -ForegroundColor Yellow
}
if (Test-Path package-lock.json) { 
    Remove-Item -Force package-lock.json 
    Write-Host "Removed package-lock.json" -ForegroundColor Yellow
}

Write-Host "Clearing npm cache..." -ForegroundColor Cyan
npm cache clean --force

Write-Host "Installing dependencies (this may take a few minutes)..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nStarting dev server..." -ForegroundColor Green
    npm run dev
} else {
    Write-Host "`nInstall failed. Try these steps:" -ForegroundColor Red
    Write-Host "1. Close all programs (VS Code, terminals, etc.) that might lock files"
    Write-Host "2. Temporarily disable Windows Defender real-time protection"
    Write-Host "3. Move project to shorter path: C:\shoppus (copy folder, then run from there)"
    Write-Host "4. Run PowerShell as Administrator and run this script again"
}
