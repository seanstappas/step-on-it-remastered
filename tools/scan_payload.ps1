$found = New-Object System.Collections.ArrayList
$flagHist = @{}
Get-ChildItem extracted/levels/*.bord | ForEach-Object {
  $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
  $off = 0x18
  while ($off + 4 -le $bytes.Length) {
    $cell = (([long]$bytes[$off]) -shl 24) -bor (([long]$bytes[$off + 1]) -shl 16) -bor (([long]$bytes[$off + 2]) -shl 8) -bor ([long]$bytes[$off + 3])
    $off += 4
    if ($cell -eq 0) { break }
    while ($off + 2 -le $bytes.Length) {
      $a = $bytes[$off]; $b = $bytes[$off + 1]; $off += 2
      if ($a -eq 100 -or $b -eq 100) { break }
    }
    $flags = $cell -band 0xFF00
    $flagHist[$flags] = 1 + ($flagHist[$flags])
    if ((($cell -band 0x1000) -ne 0) -and (($cell -band 0x400) -eq 0)) {
      [void]$found.Add([pscustomobject]@{ File = $_.Name; Cell = ("0x{0:X8}" -f $cell); Payload = ("0x{0:X}" -f (($cell -shr 16) -band 0xFFFF)); Low = ("0x{0:X2}" -f ($cell -band 0xFF)) })
    }
  }
}
"=== flag-byte (cell & 0xFF00) histogram across all boards ==="
$flagHist.GetEnumerator() | Sort-Object Name | ForEach-Object { "  0x{0:X4} : {1}" -f $_.Name, $_.Value }
""
"=== payload cells (0x1000 set, not spawn) : $($found.Count) ==="
$found | Group-Object Cell | Sort-Object Count -Descending | Select-Object -First 20 | ForEach-Object { "  {0}  x{1}" -f $_.Name, $_.Count }
""
"first few examples:"
$found | Select-Object -First 8 | Format-Table -AutoSize
