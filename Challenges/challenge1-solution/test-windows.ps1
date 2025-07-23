# CoderCo Challenge 1 - Windows PowerShell Test Script
# This script tests the Docker deployment on Windows

param(
    [string]$BaseUrl = "http://localhost",
    [switch]$StartDocker,
    [switch]$StopDocker,
    [switch]$Help
)

function Show-Help {
    Write-Host "CoderCo Challenge 1 - Windows Testing Script" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\test-windows.ps1 [OPTIONS]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -StartDocker    Start Docker containers"
    Write-Host "  -StopDocker     Stop Docker containers"
    Write-Host "  -BaseUrl <url>  Base URL for testing (default: http://localhost)"
    Write-Host "  -Help           Show this help message"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\test-windows.ps1 -StartDocker    # Start containers and test"
    Write-Host "  .\test-windows.ps1                 # Just run tests"
    Write-Host "  .\test-windows.ps1 -StopDocker     # Stop containers"
}

function Test-DockerAvailable {
    try {
        $null = docker --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Test-Endpoint {
    param(
        [string]$Url,
        [string]$TestName,
        [int]$ExpectedStatus = 200
    )
    
    Write-Host "Testing $TestName... " -NoNewline
    
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "✅ PASS" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ FAIL (Status: $($response.StatusCode))" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ FAIL (Error: $($_.Exception.Message))" -ForegroundColor Red
        return $false
    }
}

function Start-DockerContainers {
    Write-Host "Starting Docker containers..." -ForegroundColor Yellow
    
    if (-not (Test-DockerAvailable)) {
        Write-Host "❌ Docker is not available. Please install Docker Desktop." -ForegroundColor Red
        return $false
    }
    
    try {
        Write-Host "Building and starting containers..."
        docker-compose up -d --build
        
        Write-Host "Waiting for services to start..." -ForegroundColor Yellow
        Start-Sleep -Seconds 30
        
        Write-Host "Checking container status..."
        docker-compose ps
        
        return $true
    }
    catch {
        Write-Host "❌ Failed to start Docker containers: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Stop-DockerContainers {
    Write-Host "Stopping Docker containers..." -ForegroundColor Yellow
    
    try {
        docker-compose down
        Write-Host "✅ Containers stopped successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to stop containers: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Test-Application {
    param([string]$BaseUrl)
    
    Write-Host "`n🧪 Running Application Tests" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    
    $tests = @(
        @{ Name = "Main Dashboard"; Url = "$BaseUrl/" }
        @{ Name = "Health Check"; Url = "$BaseUrl/health" }
        @{ Name = "API Status"; Url = "$BaseUrl/api/status" }
        @{ Name = "API Metrics"; Url = "$BaseUrl/api/metrics" }
        @{ Name = "404 Error Handling"; Url = "$BaseUrl/nonexistent"; ExpectedStatus = 404 }
    )
    
    $passed = 0
    $total = $tests.Count
    
    foreach ($test in $tests) {
        $status = if ($test.ExpectedStatus) { $test.ExpectedStatus } else { 200 }
        if (Test-Endpoint -Url $test.Url -TestName $test.Name -ExpectedStatus $status) {
            $passed++
        }
    }
    
    Write-Host "`n📊 Test Results:" -ForegroundColor Cyan
    Write-Host "Total Tests: $total"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $($total - $passed)" -ForegroundColor Red
    
    if ($passed -eq $total) {
        Write-Host "`n🎉 All tests passed! Application is working correctly." -ForegroundColor Green
    } else {
        Write-Host "`n⚠️ Some tests failed. Check Docker containers and logs." -ForegroundColor Yellow
    }
    
    return ($passed -eq $total)
}

function Show-ApplicationInfo {
    Write-Host "`n🌐 Application URLs:" -ForegroundColor Cyan
    Write-Host "Main Dashboard: $BaseUrl/"
    Write-Host "Health Check: $BaseUrl/health"
    Write-Host "API Status: $BaseUrl/api/status"
    Write-Host "System Metrics: $BaseUrl/api/metrics"
    
    Write-Host "`n🔧 Docker Commands:" -ForegroundColor Cyan
    Write-Host "View logs: docker-compose logs -f coderco-app"
    Write-Host "Container status: docker-compose ps"
    Write-Host "Stop containers: docker-compose down"
    Write-Host "Restart: docker-compose restart"
}

function Main {
    Write-Host "CoderCo Challenge 1 - Windows Testing" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    
    if ($Help) {
        Show-Help
        return
    }
    
    if ($StopDocker) {
        Stop-DockerContainers
        return
    }
    
    if ($StartDocker) {
        if (-not (Start-DockerContainers)) {
            Write-Host "`n❌ Failed to start Docker containers. Cannot proceed with testing." -ForegroundColor Red
            return
        }
    }
    
    # Run tests
    $testResult = Test-Application -BaseUrl $BaseUrl
    
    if ($testResult) {
        Show-ApplicationInfo
        
        Write-Host "`n🎯 Next Steps:" -ForegroundColor Yellow
        Write-Host "1. Open $BaseUrl in your browser to see the dashboard"
        Write-Host "2. Try the API endpoints listed above"
        Write-Host "3. Check container logs: docker-compose logs -f"
        Write-Host "4. For production deployment, use the Linux deployment script"
    }
}

# Run main function
Main
