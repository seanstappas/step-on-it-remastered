param([string]$Board = "extracted/levels/board_489.bord")
$bytes = [System.IO.File]::ReadAllBytes($Board)
$cells = @{}
$off = 0x18
while ($off + 4 -le $bytes.Length) {
  $cell = (([long]$bytes[$off]) -shl 24) -bor (([long]$bytes[$off + 1]) -shl 16) -bor (([long]$bytes[$off + 2]) -shl 8) -bor ([long]$bytes[$off + 3])
  $off += 4
  if ($cell -eq 0) { break }
  $n = 0
  while ($off + 2 -le $bytes.Length) { $a = $bytes[$off]; $b = $bytes[$off + 1]; $off += 2; if ($a -eq 100 -or $b -eq 100) { break }; $n++ }
  $k = "0x{0:X8}" -f $cell
  $cells[$k] = $n + ($cells[$k])
}
"$Board distinct cell values (value : low/flag : placements):"
$cells.GetEnumerator() | Sort-Object { [Convert]::ToInt64($_.Name, 16) } | ForEach-Object {
  $c = [Convert]::ToInt64($_.Name, 16); $low = $c -band 0xFF; $fb = ($c -band 0xFF00) -shr 8
  "  {0}  low=0x{1:X2} flagB=0x{2:X2}  x{3}" -f $_.Name, $low, $fb, $_.Value
}