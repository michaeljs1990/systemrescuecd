EAPI="2"
ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.9.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
DEPEND="sys-devel/bc"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-3.9.tar.bz2
	mv linux-3.9 linux-${KV}
	ln -s linux-${KV} linux
	cd linux-${KV}

	epatch ${FILESDIR}/alt-sources-3.9-01-stable-3.9.10.patch.bz2 || die "alt-sources stable patch failed."
	epatch ${FILESDIR}/alt-sources-3.9-02-fc17.patch.bz2 || die "alt-sources fedora patch failed."
	epatch ${FILESDIR}/alt-sources-3.9-03-aufs.patch.bz2 || die "alt-sources aufs patch failed."
	epatch ${FILESDIR}/alt-sources-3.9-04-reiser4.patch.bz2 || die "alt-sources reiser4 patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e "${sedlockdep}" include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e "${sednoagp}" drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -alt371/" Makefile
}
