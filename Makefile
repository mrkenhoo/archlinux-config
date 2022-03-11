all: install-kernels
		systemctl enable --now {apparmor,ananicy,firewalld}

install-kernels: setup-rootfs
		[ -f "kernels/setup.sh" ] && sudo sh "kernels/setup.sh"

setup-rootfs: install-packages
		[ -f "rootfs/setup.sh" ] && sudo sh "rootfs/setup.sh"

install-packages:
		[ -f "packages/setup.sh" ] && sh "packages/setup.sh"
