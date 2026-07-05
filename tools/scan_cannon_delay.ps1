$rows = New-Object System.Collections.ArrayList
Get-ChildItem extracted/levels/*.bord | ForEach-Object {
  $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
  $off = 0x18
  while ($off + 4 -le $bytes.Length) {
    $cell = (([long]$bytes[$off]) -shl 24) -bor (([long]$bytes[$off + 1]) -shl 16) -bor (([long]$bytes[$off + 2]) -shl 8) -bor ([long]$bytes[$off + 3])
    $off += 4
    if ($cell -eq 0) { break }
    while ($off + 2 -le $bytes.Length) { $a = $bytes[$off]; $b = $bytes[$off + 1]; $off += 2; if ($a -eq 100 -or $b -eq 100) { break } }
    $low = $cell -band 0xFF
    if ((($cell -band 0x400) -ne 0) -and ($low -eq 1 -or $low -eq 13)) {
      $b0 = ($cell -shr 24) -band 0xFF; $b1 = ($cell -shr 16) -band 0xFF
      [void]$rows.Add([pscustomobject]@{ b0 = $b0; b1 = $b1; reload = $b0 * 6; initial = $b1 * 6 })
    }
  }
}
"Cannon spawn blocks (placed type 1/13): $($rows.Count) total"
"reload=b0*6 initial=b1*6 frame counts; distinct (b0,b1):"
$rows | Group-Object { "b0=$($_.b0) b1=$($_.b1) -> reload=$($_.reload) initial=$($_.initial)" } | Sort-Object Count -Descending | ForEach-Object { "  {0,-48} x{1}" -f $_.Name, $_.Count }