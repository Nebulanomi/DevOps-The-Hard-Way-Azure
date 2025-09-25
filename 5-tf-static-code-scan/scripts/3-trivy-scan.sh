# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.66.0

# Run Trivy IaC Scan locally on root of repo
trivy config .

# To run on GitHub Actions, add the following to .github/workflows/main.yml

- name: Run Trivy IaC scan
    uses: aquasecurity/trivy-action@0.21.0
    with:
    scan-type: config
    scanners: misconfig
    ignore-unfixed: true
    format: sarif
    output: trivy-results.sarif
    exit-code: 0   # ensures workflow does not fail, similar to --soft-fail

- name: Upload Trivy scan results to GitHub Security tab
    uses: github/codeql-action/upload-sarif@v2
    with:
    sarif_file: trivy-results.sarif