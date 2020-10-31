# WSL2 on Windows 10

## Install WSL2 and Docker

- First install WSL2 with instructions: https://docs.microsoft.com/en-us/windows/wsl/install-win10
- Next in Microsoft Store search and install `Ubuntu` or `Debian`.
- Then you need to install Docker Desktop. You can download it from https://hub.docker.com/editions/community/docker-ce-desktop-windows
- Make sure that you check `Use the WSL2 based engine` option in Docker Desktop settings.

## Install Stonehenge in PowerShell

### Oneliner:

```
$ iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/druidfi/stonehenge/3e9e7d0a757a35e5b3092a5f20dd779b88455d28/install.ps1'))
```

### Or manually with Git

```
$ wsl sh -c "sudo apt update && sudo apt upgrade && sudo apt install build-essential"
$ wsl git clone -b 2.x https://github.com/druidfi/stonehenge.git ~/stonehenge
$ wsl make -s -C ~/stonehenge up
$ $WSL_NAME = $(wsl sh -c 'echo $WSL_DISTRO_NAME')
$ $WSL_USER = $(wsl whoami)
$ Import-Certificate -Filepath \\wsl$\$WSL_NAME\home\$WSL_USER\stonehenge\certs\rootCA.pem -CertStoreLocation cert:\CurrentUser\Root
```

## DNS configuration

You need to route traffic from *.docker.sh to WSL2, so we need to add Stonehenge's
dnsmasq service bind to 127.0.0.48 to DnsClient.

Open Powershell terminal and run command:

```
$ Get-DnsClientServerAddress
```

Check correct Interface Index. Usually when you have a wired connection it is `Ethernet` and with wireless it's `WiFi`.

When you have the correct Interface Index, run this command:

Note! You need to run Powershell terminal as an administrator for this command!

```
$ Set-DnsClientServerAddress -InterfaceIndex INTERFACE_INDEX -ServerAddresses ("127.0.0.48","1.1.1.1")
```

Finally flush your DNS with:

```
$ ipconfig -flushdns
```
