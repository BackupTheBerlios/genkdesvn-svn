# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kplayer
inherit kde kde-source

need-kde 3

DESCRIPTION="KPlayer is a KDE media player based on mplayer."
HOMEPAGE="http://kplayer.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="media-video/mplayer"
