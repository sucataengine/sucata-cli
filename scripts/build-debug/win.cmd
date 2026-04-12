echo Building Debug Sucata CLI for Windows...

echo Building debug sucata.exe...
odin build src/ -out:sucata.exe  -debug -sanitize:address

echo Done!

