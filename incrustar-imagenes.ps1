# Incrusta assets/frente, assets/reverso y assets/retrato (png|jpg|webp) dentro de assets/imagenes.js
# Uso: clic derecho -> "Ejecutar con PowerShell"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$assets = Join-Path $dir 'assets'

function ADatos($nombre) {
  foreach ($ext in 'png', 'jpg', 'jpeg', 'webp') {
    $ruta = Join-Path $assets "$nombre.$ext"
    if (Test-Path $ruta) {
      $mime = if ($ext -eq 'jpg') { 'jpeg' } else { $ext }
      Write-Host "  + $nombre.$ext"
      return '"data:image/' + $mime + ';base64,' + [Convert]::ToBase64String([IO.File]::ReadAllBytes($ruta)) + '"'
    }
  }
  return 'null'
}

Write-Host 'Incrustando imagenes...'
$frente = ADatos 'frente'
$reverso = ADatos 'reverso'
$retrato = ADatos 'retrato'
$js = "// Generado por incrustar-imagenes.ps1`nwindow.TARJETA = { frente: $frente, reverso: $reverso, retrato: $retrato };`n"
[IO.File]::WriteAllText((Join-Path $assets 'imagenes.js'), $js)
Write-Host 'Listo. Abre index.html para verla.'
Start-Sleep -Seconds 2
