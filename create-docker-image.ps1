param (
    [string]$imageName
)

if ([string]::IsNullOrWhiteSpace($imageName)) {
    Write-Host "Error: The image name parameter is empty." -ForegroundColor Red
    exit 1
}

# Display the input image name
Write-Host "Building Docker image with name: $imageName"

# Run the Docker build command with the specified image name
docker build -t $imageName .

# Check if the build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker image '$imageName' built successfully."
} else {
    Write-Host "Docker build failed."
    exit 1
}
