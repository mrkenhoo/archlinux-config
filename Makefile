all: check setup-secure-boot

setup-secure-boot: install-kernels
	[ -f "tools/setup.sh" ] && sh "tools/setup.sh"

install-kernels: setup-rootfs
	[ -f "kernels/setup.sh" ] && sh "kernels/setup.sh"

setup-rootfs: setup-services
	[ -f "rootfs/setup.sh" ] && sh "rootfs/setup.sh"

setup-services: install-packages
	sudo systemctl enable --now apparmor.service && \
		sudo systemctl enable --now firewalld.service && \
		sudo systemctl enable --now bluetooth.service && \
		sudo systemctl enable --now libvirtd.socket && \
		sudo systemctl enable --now libvirtd-ro.socket && \
		sudo systemctl enable --now libvirtd-admin.socket && \
		sudo systemctl enable --now fancontrol.service && \
		sudo systemctl enable --now systemd-boot-update.service && \
		sudo systemctl enable --now cronie.service && \
		sudo systemctl enable --now fstrim.timer && \
		sudo systemctl enable --now clamav-freshclam.service && \
    	systemctl enable --now --user pipewire-pulse.socket || \
		exit 1

install-packages:
	[ -f "packages/setup.sh" ] && sh "packages/setup.sh"

update-tkg-kernel:
	[ -f "kernels/setup.sh" ] && sh "kernels/setup.sh"

check:
	[ ! -d "kernels" ] && exit 1 && \
	[ ! -d "packages" ] && exit 1 && \
	[ ! -d "rootfs" ] && exit 1 && \
	[ ! -d "tools" ] && exit 1 && \
    [ "`whoami`" = "root" ] && \
	    echo "Please do not use the root user" && exit 1
