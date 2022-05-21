all: install-kernels
	systemctl enable --now apparmor && \
	systemctl enable --now firewalld && \
	systemctl enable --now bluetooth && \
	systemctl enable --now libvirtd.socket && \
	systemctl enable --now libvirtd-ro.socket && \
	systemctl enable --now libvirtd-admin.socket || exit 1

install-kernels: setup-rootfs
	[ -f "kernels/setup.sh" ] && sh "kernels/setup.sh"

setup-rootfs: install-packages
	[ -f "rootfs/setup.sh" ] && sudo sh "rootfs/setup.sh"

install-packages: install-arch
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
	[ -d "tools" ] && echo "Directory tools was found" || exit 1
