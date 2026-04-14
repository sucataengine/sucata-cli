$OdinRoot = odin root
$OdinShared = "$OdinRoot\shared"

Set-Location $OdinShared

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue http

git clone https://github.com/laytan/odin-http.git
Move-Item .\odin-http\client .\http
Remove-Item -Recurse -Force odin-http