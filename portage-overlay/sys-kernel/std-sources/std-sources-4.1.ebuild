EAPI="3"
ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v4.x/linux-4.1.tar.xz"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.system-rescue-cd.org"
DEPEND="sys-devel/bc"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-4.1.tar.xz
	mv linux-4.1 linux-${KV}
	ln -s linux-${KV} linux
	cd linux-${KV}

	epatch ${FILESDIR}/std-sources-4.1-01-stable-4.1.27.patch.xz || die "std-sources stable patch failed."
	epatch ${FILESDIR}/std-sources-4.1-02-fc21.patch.xz || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/std-sources-4.1-03-aufs.patch.xz || die "std-sources aufs patch failed."
	epatch ${FILESDIR}/std-sources-4.1-04-reiser4.patch.xz || die "std-sources reiser4 patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e "${sedlockdep}" include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e "${sednoagp}" drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -std480/" Makefile
}

