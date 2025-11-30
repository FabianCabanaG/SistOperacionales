<#
run_tests.ps1
Script de ejemplo para ejecutar pruebas de carga con `ab` o `siege` y recolectar métricas.
Ejecutar desde PowerShell en la carpeta `Entregas`.
#>

param(
    [string]$url = "http://192.168.2.9/",
    [int]$requests = 1000,
    [int]$concurrency = 50,
    [string]$output = "results.csv"
)

Write-Host "Prueba de carga: $url - requests: $requests - concurrency: $concurrency"

# Intentar usar ab si está disponible
if (Get-Command ab -ErrorAction SilentlyContinue) {
    $cmd = "ab -n $requests -c $concurrency $url"
    Write-Host "Ejecutando: $cmd"
    $out = & ab -n $requests -c $concurrency $url 2>&1
    $timestamp = Get-Date -Format o
    # Extraer algunas métricas básicas (requests per second, time per request)
    $rps = ($out | Select-String "Requests per second" -SimpleMatch).ToString()
    $tpr = ($out | Select-String "Time per request" -SimpleMatch).ToString()
    $line = "$timestamp,$requests,$concurrency,`"$rps`",`"$tpr`""
    Add-Content -Path $output -Value $line
    Write-Host "Resultados guardados en $output"
} elseif (Get-Command siege -ErrorAction SilentlyContinue) {
    $cmd = "siege -c $concurrency -r $([math]::Ceiling($requests/$concurrency)) $url"
    Write-Host "Ejecutando: $cmd"
    $out = & siege -c $concurrency -r $([math]::Ceiling($requests/$concurrency)) $url 2>&1
    $timestamp = Get-Date -Format o
    Add-Content -Path $output -Value ("$timestamp, siege output, see log")
    Write-Host "Resultados guardados en $output"
} else {
    Write-Warning "Ni 'ab' ni 'siege' están instalados en este sistema. Instale alguno para ejecutar pruebas de carga."
}
