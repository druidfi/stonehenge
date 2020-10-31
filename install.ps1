#wsl sh -c "sudo apt update && sudo apt upgrade && sudo apt install build-essential"
#wsl git clone -b 2.x https://github.com/druidfi/stonehenge.git ~/stonehenge
wsl make -s -C ~/stonehenge up

$WSL_NAME = $(wsl sh -c 'echo $WSL_DISTRO_NAME')
$WSL_USER = $(wsl whoami)

Import-Certificate -Filepath \\wsl$\$WSL_NAME\home\$WSL_USER\stonehenge\certs\rootCA.pem -CertStoreLocation cert:\CurrentUser\Root
