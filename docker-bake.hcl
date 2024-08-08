variable "REPO_NAME" {
    default = "druidfi/stonehenge"
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
    tags = ["${REPO_NAME}:5", "${REPO_NAME}:5.0", "${REPO_NAME}:latest"]
}
