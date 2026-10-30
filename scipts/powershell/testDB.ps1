# xxx.liveservice.fpa.rbxd.ds,1433
# 127.0.0.1,1522

& sqlcmd `
    -S "127.0.0.1,1522" `
    -d "ls-all-db" `
    -U "LS_ALL" `
    -P "hello00" `
    -N `
    -Q "SELECT @@SERVERNAME AS ServerName, DB_NAME() AS DatabaseName;"

Write-Host "Exit code: $LASTEXITCODE"