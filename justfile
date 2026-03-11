export LUA_CPATH := "./crystal/lib/target/release/lib?.so;./crystal/lib/target/release/?.dll"

run: setup-love build
    love game

test: setup-love build
    love game /test

test-crystal: setup-love build
    love crystal/runtime /test

[working-directory: 'crystal/lib']
build:
    cargo build --release

upstream:
    git subrepo pull crystal
    git subrepo push crystal

[windows]
setup-love:
    #!powershell
    if (Test-Path love) {
        Remove-Item -Path love -Recurse
    }
    New-Item -Type dir -Force love | Out-Null
    $love = Resolve-Path love

    $zip = New-TemporaryFile
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip" -OutFile $zip
    Expand-Archive $zip -DestinationPath $love -Force
    Remove-Item $zip
    Get-ChildItem -Path $love -Recurse -File | Move-Item -Destination $love
    Get-ChildItem -Path $love -Recurse -Directory | Remove-Item

    $regexAddPath = [regex]::Escape($love)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $addPath) -join ';'

[linux]
setup-love:

[windows]
package: setup-love build
    #!powershell
    if (Test-Path packaged) {
        Remove-Item -Path packaged -Recurse
    }
    New-Item -Type dir -Force packaged | Out-Null

    Compress-Archive -Path game/* -DestinationPath packaged/game.love
    Get-Content -AsByteStream love\love.exe, packaged\game.love | Set-Content -AsByteStream packaged\crystal-sample-game.exe
    Remove-Item -Path packaged/game.love
    Copy-Item love/*.dll, love/license.txt, lib/target/release/*.dll packaged

