$REPO_FOLDER=~/stonehenge
$REPO_URL=https://github.com/druidfi/stonehenge.git
$REPO_BRANCH=3.x
$WSL_NAME = $(wsl sh -c 'echo $WSL_DISTRO_NAME')
$WSL_USER = $(wsl whoami)

# Install needed packages to WSL
wsl sh -c "sudo apt update && sudo apt upgrade && sudo apt install build-essential"

# Clone Stonehenge to WSL
wsl git clone -b $REPO_BRANCH $REPO_URL $REPO_FOLDER

# Start Stonehenge
wsl make -s -C ~/stonehenge up

# Import Stonehenge certificate
Import-Certificate -Filepath \\wsl$\$WSL_NAME\home\$WSL_USER\stonehenge\certs\rootCA.pem -CertStoreLocation cert:\CurrentUser\Root
