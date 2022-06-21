all: check install-kernels
	sudo systemctl enable --now apparmor && \
	sudo systemctl enable --now firewalld && \
	sudo systemctl enable --now bluetooth && \
	sudo systemctl enable --now libvirtd.socket && \
	sudo systemctl enable --now libvirtd-ro.socket && \
	sudo systemctl enable --now libvirtd-admin.socket && \
	sudo systemctl enable --now fancontrol.service && \
	sudo systemctl enable --now systemd-boot-update.service && \
	sudo systemctl enable --now docker.socket && \
	sudo systemctl enable --now cronie && \
	sudo systemctl enable --now fstrim.timer && \
	sudo systemctl enable gdm.service && \
	sudo systemctl set-default graphical.target && \
	sudo pwmconfig || exit 1

install-kernels: setup-rootfs
	[ -f "kernels/setup.sh" ] && sh "kernels/setup.sh"

setup-rootfs: install-packages
	[ -f "rootfs/setup.sh" ] && sh "rootfs/setup.sh"

install-packages: install-arch
	git submodule init && \
	git config submodule.https://github.com/p-mng/proton-ge-custom-updater.git \
		packages/proton-ge-custom-updater && \
	git submodule update && \
	sh tools/archfi/archfi
	[ -f "packages/setup.sh" ] && sh "packages/setup.sh"

install-arch:
	[ ! -d "tools" ] && mkdir -v "tools" || \
	git submodule init && \
	git config submodule.https://github.com/MatMoul/archfi.git tools/archfi && \
	git submodule update && \
	sh tools/archfi/archfi

update-tkg-kernel:
	[ -f "kernels/setup.sh" ] && sh "kernels/setup.sh"

check:
	[ -d "kernels" ] && echo "Directory kernels was found" && \
	[ -d "packages" ] && echo "Directory packages was found" && \
	[ -d "rootfs" ] && echo "Directory rootfs was found" && \
	[ -d "tools" ] && echo "Directory tools was found" && \
        [ "`whoami`" = "root" ] && \
	        echo ":: ERROR: Please use your own user instead of using root and try again" && \
	        exit 1 || echo "Current user is not root"
