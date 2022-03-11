all: install-kernels
		systemctl enable --now apparmor && \
		systemctl enable --now firewalld && \
		systemctl enable --now bluetooth && \
		systemctl enable --now libvirtd.socket && \
		systemctl enable --now libvirtd-ro.socket && \
		systemctl enable --now libvirtd-admin.socket

install-kernels: setup-rootfs
		[ -f "kernels/setup.sh" ] && sudo sh "kernels/setup.sh"

setup-rootfs: install-packages
		[ -f "rootfs/setup.sh" ] && sudo sh "rootfs/setup.sh"

install-packages:
		[ -f "packages/setup.sh" ] && sh "packages/setup.sh"
