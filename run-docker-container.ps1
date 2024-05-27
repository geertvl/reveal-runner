param (
    [string]$imageName,
    [string]$containerName
)

function Get-ContainerState {
    param (
        [string]$name
    )
    $container = docker ps -a --filter "name=$containerName" --format "{{.ID}} {{.State}}"
    return $container
}

if ([string]::IsNullOrWhiteSpace($imageName)) {
    Write-Host "Error: The image name parameter is empty." -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($containerName)) {
    Write-Host "Error: The container name parameter is empty." -ForegroundColor Red
    exit 1
}

$containerState = Get-ContainerState -name $containerName
if (-not $containerState) {
    Write-Host "Container '$containerName' does not exist."
    exit 1
} else {
    $state = $containerState.Split()[1]
    Write-Host "Container '$containerName' is in state '$state'."
}

if ($state -eq "running" -or $state -eq "restarting") {
    Write-Host "Stopping container '$containerName'..."
    docker stop $containerName

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container '$containerName' removed successfully."
    } else {
        Write-Host "Failed to remove container '$containerName'." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Container '$containerName' is already being removed."
}

if ($state -ne "removing") {
    Write-Host "Removing container '$containerName'..."
    docker rm $containerName

    # Check if the remove command was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container '$containerName' removed successfully."
    } else {
        Write-Host "Failed to remove container '$containerName'."
        exit 1
    }
} else {
    Write-Host "Container '$containerName' is already being removed."
}

docker run -dit --name $containerName -p 8080:80 $imageName