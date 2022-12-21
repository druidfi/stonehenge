variable "REPO_NAME" {
    default = "druidfi/stonehenge"
}

variable "TRAEFIK_VERSION" {
    default = "2.9.6"
}

group "default" {
    targets = ["traefik"]
}

target "common" {
    platforms = ["linux/amd64", "linux/arm64"]
}

#
# Stonehenge Traefik
#

target "traefik" {
    inherits = ["common"]
    context = "."
    args = {
        TRAEFIK_VERSION = "${TRAEFIK_VERSION}"
    }
    tags = ["${REPO_NAME}:4", "${REPO_NAME}:4.0", "${REPO_NAME}:latest"]
}
