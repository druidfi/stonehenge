# WSL2 on Windows 10

## Install WSL2 and Docker

- First install WSL2 with instructions: https://docs.microsoft.com/en-us/windows/wsl/install-win10
- Next in Microsoft Store search and install `Ubuntu LTS` or `Debian`.
- Then you need to install Docker Desktop. You can download it from https://hub.docker.com/editions/community/docker-ce-desktop-windows
- Make sure that you check `Use the WSL2 based engine` option in Docker Desktop settings.

## Install Stonehenge in PowerShell

### Oneliner:

```
$ iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/druidfi/stonehenge/3.x/install.ps1'))
```

### Or manually with Git

```
$ wsl sh -c "sudo apt update && sudo apt upgrade && sudo apt install build-essential"
$ wsl git clone -b 3.x https://github.com/druidfi/stonehenge.git ~/stonehenge
$ wsl make -s -C ~/stonehenge up
$ $WSL_NAME = $(wsl sh -c 'echo $WSL_DISTRO_NAME')
$ $WSL_USER = $(wsl whoami)
$ Import-Certificate -Filepath \\wsl$\$WSL_NAME\home\$WSL_USER\stonehenge\certs\rootCA.pem -CertStoreLocation cert:\CurrentUser\Root
```
