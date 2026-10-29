# server.liveservice.fpa.rbxd.ds,1433
# localhost:1522

& sqlcmd `
    -S "127.0.0.1,1522" `
    -d "ls-all-db" `
    -U "LS_ALL" `
    -P "hello00" `
    -l 5 `
    -b `
    -Q "SELECT @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName;"

Write-Host "Exit code: $LASTEXITCODE"