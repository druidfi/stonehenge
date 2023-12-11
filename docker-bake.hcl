variable "REPO_NAME" {
    default = "druidfi/stonehenge"
}

variable "TRAEFIK_VERSION" {
    default = "2.10.7"
}

group "default" {
    targets = ["traefik"]
}

target "common" {
    platforms = ["linux/amd64", "linux/arm64"]
    labels = {
        "org.opencontainers.image.url" = "https://github.com/druidfi/stonehenge"
        "org.opencontainers.image.source" = "https://github.com/druidfi/stonehenge"
        "org.opencontainers.image.licenses" = "MIT"
        "org.opencontainers.image.vendor" = "Druid Oy"
        "org.opencontainers.image.created" = "${timestamp()}"
    }
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
    tags = ["${REPO_NAME}:4", "${REPO_NAME}:4.1", "${REPO_NAME}:latest"]
}
