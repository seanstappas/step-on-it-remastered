$vals = @{}
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
    $low = $cell -band 0xFF
    if ($low -eq 1 -or $low -eq 2 -or $low -eq 3 -or $low -eq 0x0B -or ($low -ge 4 -and $low -le 9)) {
      $key = "0x{0:X8}" -f $cell
      $vals[$key] = 1 + $vals[$key]
    }
  }
}
"=== full cell values for low bytes in {1,2,3, 4-9, 0x0B} (key/door/lock candidates) ==="
$vals.GetEnumerator() | Sort-Object Name | ForEach-Object {
  $c = [Convert]::ToInt64($_.Name, 16)
  $low = $c -band 0xFF
  $flags = ($c -band 0xFF00) -shr 8
  $high = ($c -shr 16) -band 0xFFFF
  "  {0}  low=0x{1:X2} flagB=0x{2:X2} high=0x{3:X4}  x{4}" -f $_.Name, $low, $flags, $high, $_.Value
}
