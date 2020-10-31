# WSL2 on Windows 10

## Install

- First install WSL2 with instructions: https://docs.microsoft.com/en-us/windows/wsl/install-win10

- Next in Microsoft Store search and install `Ubuntu` or `Debian`.

- Then you need to install Docker Desktop. You can download it from https://hub.docker.com/editions/community/docker-ce-desktop-windows

- Make sure that you check `Use the WSL2 based engine` option in Docker Desktop settings.

## In WSL terminal

Install the needed packages:

```
$ sudo apt update && sudo apt upgrade && sudo apt install build-essential
```

Setup your SSH keys:

- Copy your ssh key over to ~/.ssh/
- Test with `ssh -T git@github.com`. You should get, e.g. Hi {YOURNAME}! You've successfully authenticated, but GitHub does not provide shell access.
- Fix file permissions if needed.

## DNS configuration

You need to route traffic from *.docker.sh to WSL2, so we need to add Stonehenge's
dnsmasq service bind to 127.0.0.48 to DnsClient.


Open Powershell terminal and run command:

```
$ Get-DnsClientServerAddress
```

Check correct Interface Index

Usually when you have a wired connection it is `Ethernet` and with wireless it's `WiFi`.

When you have the correct Interface Index, run this command:

Note! You need to run Powershell terminal as an administrator for this command!

```
$ Set-DnsClientServerAddress -InterfaceIndex {YOUR INTERFACE INDEX NUMBER} -ServerAddresses ("127.0.0.48","1.1.1.1")
```

Finally flush your DNS with:

```
$ ipconfig -flushdns
```

## Certificate

In WSL terminal open Stonehenge certs folder on Explorer:

```
$ cd ~/stonehenge/certs && explorer.exe .
```

Copy the path from Explorer.

In PowerShell terminal add Stonehenge rootCA.pem certificate:

```
$ Import-Certificate -Filepath '\\wsl$\Ubuntu-20.04\home\markokorhonen\stonehenge\certs\rootCA.pem' -CertStoreLocation cert:\CurrentUser\Root
```

# Whole process with wsl cli:

wsl sh -c "sudo apt update && sudo apt upgrade && sudo apt install build-essential"
wsl git clone -b 2.x https://github.com/druidfi/stonehenge.git ~/stonehenge
wsl make -C ~/stonehenge/ up
