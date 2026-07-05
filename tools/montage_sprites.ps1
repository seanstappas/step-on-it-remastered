param(
    [Parameter(Mandatory=$true)][string]$Folder,
    [Parameter(Mandatory=$true)][string]$Out,
    [int]$Cols = 12,
    [int]$Scale = 3
)
Add-Type -AssemblyName System.Drawing
$files = Get-ChildItem -Path $Folder -Filter *.png | Sort-Object { [int]([regex]::Match($_.Name, '\d+').Value) }
if ($files.Count -eq 0) { Write-Error "no png in $Folder"; exit 1 }
$first = [System.Drawing.Image]::FromFile($files[0].FullName)
$fw = $first.Width; $fh = $first.Height
$first.Dispose()
$cw = $fw * $Scale + 8
$ch = $fh * $Scale + 18
$rows = [math]::Ceiling($files.Count / $Cols)
$bmp = New-Object System.Drawing.Bitmap ($cw * $Cols), ($ch * $rows)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::FromArgb(40,40,48))
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$font = New-Object System.Drawing.Font('Consolas', 8)
$brush = [System.Drawing.Brushes]::Yellow
for ($i = 0; $i -lt $files.Count; $i++) {
    $col = $i % $Cols
    $row = [math]::Floor($i / $Cols)
    $x = $col * $cw + 4
    $y = $row * $ch + 14
    $img = [System.Drawing.Image]::FromFile($files[$i].FullName)
    $g.DrawImage($img, $x, $y, ($fw * $Scale), ($fh * $Scale))
    $img.Dispose()
    $label = ($files[$i].Name -replace '_.*$','') -replace '\.png$',''
    $g.DrawString($label, $font, $brush, ($col * $cw + 2), ($row * $ch))
}
$g.Dispose()
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "wrote $Out ($($files.Count) frames, $($files[0].Name) size ${fw}x${fh})"
