# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kplayer
inherit kdesvn kdesvn-source

DESCRIPTION="KPlayer is a KDE media player based on mplayer."
HOMEPAGE="http://kplayer.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="media-video/mplayer"

need-kde 3.1
