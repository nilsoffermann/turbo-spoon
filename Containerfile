ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

RUN wget https://raw.githubusercontent.com/ValveSoftware/steam-devices/master/60-steam-input.rules -O /etc/udev/rules.d/60-steam-input.rules
RUN wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale-fedora.repo

RUN wget -c https://github.com/bikass/kora/archive/refs/tags/v1.6.1.zip
RUN unzip -o -qq v1.6.1.zip 'kora-1.6.1/kora/*' 'kora-1.6.1/kora-light/*' 'kora-1.6.1/kora-light-panel/*' 'kora-1.6.1/kora-pgrey/*' -d .
RUN mv ./kora-1.6.1/kora /usr/share/icons/
RUN mv ./kora-1.6.1/kora-light /usr/share/icons/
RUN mv ./kora-1.6.1/kora-light-panel /usr/share/icons/
RUN mv ./kora-1.6.1/kora-pgrey /usr/share/icons/
RUN rm -rf ./kora-1.6.1 ./v1.6.1.zip

RUN rm /opt
RUN ln -sf usr/lib/opt /opt

COPY etc /etc

RUN rpm-ostree override remove firefox firefox-langpacks nano-default-editor nano \
gnome-classic-session gnome-tour gnome-shell-extension-apps-menu gnome-shell-extension-launch-new-instance \
gnome-shell-extension-places-menu gnome-shell-extension-window-list gnome-shell-extension-background-logo
RUN rpm-ostree install breeze-cursor-theme cosmic-term dash fira-code-fonts htop micro open-sans-fonts rsms-inter-fonts tailscale zsh wireshark

COPY usr /usr

RUN systemctl enable dconf-update.service
RUN systemctl enable tailscaled.service
RUN sed -i '1 i #!/usr/bin/bash' /etc/grub.d/10_linux && sed -i '2d' /etc/grub.d/10_linux
RUN ln -sfT /usr/bin/dash /usr/bin/sh
RUN rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo
RUN rm -f /etc/yum.repos.d/tailscale-fedora.repo

RUN ostree container commit
