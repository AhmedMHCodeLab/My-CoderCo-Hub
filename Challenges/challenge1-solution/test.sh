#!/bin/bash

# CoderCo App Testing Script
# This script tests all endpoints and functionality of the deployed application

set -euo pipefail

# Configuration
BASE_URL="${BASE_URL:-http://localhost}"
APP_PORT="${APP_PORT:-5000}"
TIMEOUT=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_status="${3:-200}"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test HTTP endpoint
test_http_endpoint() {
    local endpoint="$1"
    local expected_status="${2:-200}"
    local method="${3:-GET}"
    local data="${4:-}"
    
    local curl_cmd="curl -s -o /dev/null -w '%{http_code}' --connect-timeout $TIMEOUT"
    
    if [[ "$method" == "POST" && -n "$data" ]]; then
        curl_cmd="$curl_cmd -X POST -H 'Content-Type: application/json' -d '$data'"
    fi
    
    local status_code=$(eval "$curl_cmd $endpoint")
    
    if [[ "$status_code" == "$expected_status" ]]; then
        return 0
    else
        echo "Expected: $expected_status, Got: $status_code" >&2
        return 1
    fi
}

# Test JSON response
test_json_response() {
    local endpoint="$1"
    local expected_key="$2"
    
    local response=$(curl -s --connect-timeout $TIMEOUT "$endpoint")
    
    if echo "$response" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('$expected_key', ''))" &>/dev/null; then
        return 0
    else
        echo "JSON response invalid or missing key: $expected_key" >&2
        return 1
    fi
}

# Main test suite
main() {
    log "Starting CoderCo App Test Suite"
    echo
    
    # Test 1: Direct application health check
    run_test "Direct app health check" "test_http_endpoint http://localhost:$APP_PORT/health 200"
    
    # Test 2: Direct application dashboard
    run_test "Direct app dashboard" "test_http_endpoint http://localhost:$APP_PORT/ 200"
    
    # Test 3: Direct app API status
    run_test "Direct app API status" "test_http_endpoint http://localhost:$APP_PORT/api/status 200"
    
    # Test 4: Direct app metrics
    run_test "Direct app metrics" "test_http_endpoint http://localhost:$APP_PORT/api/metrics 200"
    
    # Test 5: Nginx proxy health check
    run_test "Nginx proxy health check" "test_http_endpoint $BASE_URL/health 200"
    
    # Test 6: Nginx proxy dashboard
    run_test "Nginx proxy dashboard" "test_http_endpoint $BASE_URL/ 200"
    
    # Test 7: Nginx proxy API status
    run_test "Nginx proxy API status" "test_http_endpoint $BASE_URL/api/status 200"
    
    # Test 8: Nginx proxy metrics
    run_test "Nginx proxy metrics" "test_http_endpoint $BASE_URL/api/metrics 200"
    
    # Test 9: Echo service POST
    run_test "Echo service POST" "test_http_endpoint $BASE_URL/api/echo 200 POST '{\"test\":\"data\"}'"
    
    # Test 10: 404 error handling
    run_test "404 error handling" "test_http_endpoint $BASE_URL/nonexistent 404"
    
    # Test 11: JSON response validation
    run_test "JSON status response" "test_json_response $BASE_URL/api/status status"
    
    # Test 12: JSON metrics response
    run_test "JSON metrics response" "test_json_response $BASE_URL/api/metrics timestamp"
    
    # Test 13: Service status check
    run_test "Systemd service status" "systemctl is-active --quiet coderco-app"
    
    # Test 14: Nginx service status
    run_test "Nginx service status" "systemctl is-active --quiet nginx"
    
    # Test 15: Log files exist
    run_test "Application log file exists" "test -f /var/log/coderco-app/service.log"
    
    # Test 16: Error log file exists
    run_test "Error log file exists" "test -f /var/log/coderco-app/service-error.log"
    
    # Test 17: Nginx access log exists
    run_test "Nginx access log exists" "test -f /var/log/nginx/coderco-app.access.log"
    
    # Test 18: Process ownership
    run_test "Process runs as coderco user" "pgrep -u coderco gunicorn >/dev/null"
    
    echo
    log "Test Results Summary"
    echo "===================="
    echo "Total Tests: $TESTS_TOTAL"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo
        log "🎉 All tests passed! The application is working correctly."
        return 0
    else
        echo
        error "❌ Some tests failed. Please check the application configuration."
        return 1
    fi
}

# Performance test function
performance_test() {
    log "Running Performance Tests"
    echo
    
    if command -v ab &> /dev/null; then
        info "Running Apache Bench tests..."
        
        echo "Testing main page (100 requests, 10 concurrent):"
        ab -n 100 -c 10 "$BASE_URL/" | grep -E "(Requests per second|Time per request|Transfer rate)"
        
        echo
        echo "Testing API endpoint (50 requests, 5 concurrent):"
        ab -n 50 -c 5 "$BASE_URL/api/status" | grep -E "(Requests per second|Time per request|Transfer rate)"
        
    else
        warning "Apache Bench (ab) not found. Install with: sudo apt install apache2-utils"
    fi
}

# Load test function
load_test() {
    log "Running Load Tests"
    echo
    
    if command -v ab &> /dev/null; then
        info "Running load tests (1000 requests, 50 concurrent)..."
        ab -n 1000 -c 50 "$BASE_URL/" | grep -E "(Requests per second|Time per request|Failed requests|Transfer rate)"
    else
        warning "Apache Bench (ab) not found. Skipping load tests."
    fi
}

# Show help
show_help() {
    echo "CoderCo App Testing Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help         Show this help message"
    echo "  -p, --performance  Run performance tests"
    echo "  -l, --load         Run load tests"
    echo "  -a, --all          Run all tests including performance and load"
    echo
    echo "Environment Variables:"
    echo "  BASE_URL           Base URL for testing (default: http://localhost)"
    echo "  APP_PORT           Application port (default: 5000)"
    echo "  TIMEOUT            Request timeout in seconds (default: 10)"
    echo
    echo "Examples:"
    echo "  $0                          # Run basic functional tests"
    echo "  $0 --performance           # Run functional and performance tests"
    echo "  $0 --all                   # Run all tests"
    echo "  BASE_URL=http://example.com $0  # Test remote server"
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -p|--performance)
        main
        performance_test
        ;;
    -l|--load)
        main
        load_test
        ;;
    -a|--all)
        main
        performance_test
        load_test
        ;;
    "")
        main
        ;;
    *)
        error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
