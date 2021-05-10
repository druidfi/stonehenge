UP_PRE_TARGETS += download-traefik-me-certs

download-traefik-me-certs:
	$(call step,Download traefik.me certs...)
	@test -d certs/traefikme || (mkdir certs/traefikme && echo "- Folder certs/traefikme created")
	$(call download,https://traefik.me/cert.pem,certs/traefikme/cert.pem)
	$(call download,https://traefik.me/privkey.pem,certs/traefikme/privkey.pem)
