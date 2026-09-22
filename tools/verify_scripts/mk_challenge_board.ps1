$b = New-Object System.Collections.Generic.List[byte]
function U16($v) { $b.Add([byte](($v -shr 8) -band 255)); $b.Add([byte]($v -band 255)) }
function Rec([uint32]$t, $pairs) {
    $b.Add([byte](($t -shr 24) -band 255)); $b.Add([byte](($t -shr 16) -band 255))
    $b.Add([byte](($t -shr 8) -band 255)); $b.Add([byte]($t -band 255))
    foreach ($p in $pairs) { $b.Add([byte]$p[0]); $b.Add([byte]$p[1]) }
    $b.Add(0x64); $b.Add(0x64)
}
U16 0; U16 0x6d; U16 0x73; U16 3; U16 12; U16 16; U16 12; U16 3000; U16 0; U16 0; U16 0; U16 0
Rec 0x0000030D @(@(0,0),@(1,0),@(2,0),@(0,1),@(2,1),@(0,2),@(1,2),@(2,2))
Rec 0x2814050E @(,@(1,1))
Rec 0x0000090A @(,@(5,12))
Rec 0x0000090D @(,@(6,12))
Rec 0x00000907 @(,@(7,12))
Rec 0x00000904 @(,@(9,12))
0..3 | ForEach-Object { $b.Add(0) }
[IO.File]::WriteAllBytes($args[0], $b.ToArray())
