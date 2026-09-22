$b = New-Object System.Collections.Generic.List[byte]
function U16($v) { $b.Add([byte](($v -shr 8) -band 255)); $b.Add([byte]($v -band 255)) }
function Rec([uint32]$t, $pairs) {
    $b.Add([byte](($t -shr 24) -band 255)); $b.Add([byte](($t -shr 16) -band 255))
    $b.Add([byte](($t -shr 8) -band 255)); $b.Add([byte]($t -band 255))
    foreach ($p in $pairs) { $b.Add([byte]$p[0]); $b.Add([byte]$p[1]) }
    $b.Add(0x64); $b.Add(0x64)
}
# Hammer spawner (bord 6) heading right on a floor, with a breakable block in the way and a wall beyond.
U16 0; U16 0x6d; U16 0x73; U16 1; U16 12; U16 17; U16 12; U16 3000; U16 0; U16 0; U16 0; U16 0
Rec 0x00000300 @(@(1,7),@(2,7),@(3,7),@(4,7),@(5,7),@(6,7),@(7,7),@(8,7),@(9,7),@(10,7),@(11,7),@(12,7),@(13,7),@(14,7),@(12,6))
Rec 0x140a0606 @(,@(2,6))
Rec 0x00000207 @(,@(8,6))
0..3 | ForEach-Object { $b.Add(0) }
[IO.File]::WriteAllBytes($args[0], $b.ToArray())
