#!/usr/bin/env bash
# ==============================================================================
# DevOps IA-3: Pre-Deployment Validation & Security Scan Script
# Author: Francis | Project: DevOps IA-3 Academic Project
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo " Starting DevOps IA-3 Preflight Validation"
echo "=========================================================="

ERRORS=0

# 1. Secret & Sensitive File Leak Check
echo "[1/4] Checking for accidental secret or sensitive file inclusion..."
FORBIDDEN_PATTERNS=("*.key" "*.pem" "*.tfstate" "*.tfstate.backup" ".env" "*id_rsa*" "*id_ed25519*")

for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    FOUND_FILES=$(find . -maxdepth 3 -name "$pattern" ! -path "*/.git/*" || true)
    if [ -n "$FOUND_FILES" ]; then
        echo "❌ ERROR: Sensitive file matching '$pattern' found in repository:"
        echo "$FOUND_FILES"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ "$ERRORS" -eq 0 ]; then
    echo "✔ No sensitive credentials or state files detected."
fi

# 2. Web Application Structure Check
echo "[2/4] Validating web application source structure..."
REQUIRED_FILES=("index.html" "css/style.css" "js/script.js")

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ ERROR: Required web file '$file' is missing!"
        ERRORS=$((ERRORS + 1))
    else
        echo "✔ File '$file' present ($(wc -c < "$file") bytes)"
    fi
done

# Basic HTML syntax checks (checking closing tags)
if ! grep -q "</html>" index.html; then
    echo "❌ ERROR: index.html missing closing </html> tag!"
    ERRORS=$((ERRORS + 1))
else
    echo "✔ HTML structure validated."
fi

# 3. Shell Scripts Syntax & Permissions Check
echo "[3/4] Validating shell scripts syntax..."
SCRIPTS=("scripts/validate.sh" "scripts/deploy.sh" "scripts/health-check.sh")

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        if bash -n "$script"; then
            echo "✔ Script '$script' syntax valid."
        else
            echo "❌ ERROR: Syntax error in '$script'!"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 4. Terraform Configuration Validation
echo "[4/4] Validating Terraform configuration files..."
if [ -d "terraform" ]; then
    TF_FILES=("terraform/providers.tf" "terraform/variables.tf" "terraform/main.tf" "terraform/outputs.tf")
    for tf_file in "${TF_FILES[@]}"; do
        if [ ! -f "$tf_file" ]; then
            echo "❌ ERROR: Terraform file '$tf_file' missing!"
            ERRORS=$((ERRORS + 1))
        else
            echo "✔ Terraform file '$tf_file' present."
        fi
    done
fi

echo "=========================================================="
if [ "$ERRORS" -gt 0 ]; then
    echo "❌ Validation failed with $ERRORS error(s)."
    exit 1
else
    echo "✔ All preflight validation checks passed successfully!"
    exit 0
fi
