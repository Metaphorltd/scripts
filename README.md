To download and execute a PowerShell script, you can use the following commands in shell:

```sh
wget https://raw.githubusercontent.com/metaphorltd/scripts/main/hello.ps1
pwsh -c '& { . .\functions.ps1; Hello  world }'
```

Or you can use the following command:

```sh
pwsh -c '& { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/hello.ps1).Content)); Hello -message world }'
```
Note: in powershell, we dont need pwsh -c to run a script, we can just run the script directly i.e
```pwsh
& { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/hello.ps1).Content)); Hello -message world }
```