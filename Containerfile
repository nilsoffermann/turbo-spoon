ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:37

RUN rpm-ostree override remove firefox firefox-langpacks
RUN ostree container commit
