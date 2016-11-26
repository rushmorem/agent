#!/usr/bin/env sh
# Copyright 2015-2016 Intecture Developers. See the COPYRIGHT file at the
# top-level directory of this distribution and at
# https://intecture.io/COPYRIGHT.
#
# Licensed under the Mozilla Public License 2.0 <LICENSE or
# https://www.tldrlegal.com/l/mpl-2.0>. This file may not be copied,
# modified, or distributed except according to those terms.

# Undefined vars are errors
set -u

# Globals
prefix=""
libdir=""
sysconfdir=""
ostype="$(uname -s)"

case "$ostype" in
    Linux)
        prefix="/usr"
		libdir="$prefix/lib"
        sysconfdir="/etc"

		if [ -d "${libdir}64" ]; then
			libdir="${libdir}64"
		fi
        ;;

    FreeBSD)
        prefix="/usr/local"
		libdir="$prefix/lib"
        sysconfdir="$prefix/etc"
        ;;

    Darwin)
        prefix="/usr/local"
		libdir="$prefix/lib"
        sysconfdir="$prefix/etc"
        ;;

    *)
        echo "unrecognized OS type: $ostype" >&2
        exit 1
        ;;
esac

do_install() {
    if ! $(pkg-config --exists libzmq); then
        install -m 755 lib/libzmq.so.5.1.0 $libdir
        ln -s $libdir/libzmq.so.5.1.0 $libdir/libzmq.so.5
        ln -s $libdir/libzmq.so.5.1.0 $libdir/libzmq.so
		install -m 644 lib/pkgconfig/libzmq.pc $libdir/pkgconfig/
        install -m 644 include/zmq.h $prefix/include/
    fi

    if ! $(pkg-config --exists libczmq); then
        install -m 755 lib/libczmq.so.4.0.0 $libdir
        ln -s $libdir/libczmq.so.4.0.0 $libdir/libczmq.so.4
        ln -s $libdir/libczmq.so.4.0.0 $libdir/libczmq.so
		install -m 644 lib/pkgconfig/libczmq.pc $libdir/pkgconfig/
        install -m 644 include/czmq.h $prefix/include/
        install -m 644 include/czmq_library.h $prefix/include/
        install -m 644 include/czmq_prelude.h $prefix/include/
        install -m 644 include/zactor.h $prefix/include/
        install -m 644 include/zarmour.h $prefix/include/
        install -m 644 include/zauth.h $prefix/include/
        install -m 644 include/zbeacon.h $prefix/include/
        install -m 644 include/zcert.h $prefix/include/
        install -m 644 include/zcertstore.h $prefix/include/
        install -m 644 include/zchunk.h $prefix/include/
        install -m 644 include/zclock.h $prefix/include/
        install -m 644 include/zconfig.h $prefix/include/
        install -m 644 include/zdigest.h $prefix/include/
        install -m 644 include/zdir.h $prefix/include/
        install -m 644 include/zdir_patch.h $prefix/include/
        install -m 644 include/zfile.h $prefix/include/
        install -m 644 include/zframe.h $prefix/include/
        install -m 644 include/zgossip.h $prefix/include/
        install -m 644 include/zhash.h $prefix/include/
        install -m 644 include/zhashx.h $prefix/include/
        install -m 644 include/ziflist.h $prefix/include/
        install -m 644 include/zlist.h $prefix/include/
        install -m 644 include/zlistx.h $prefix/include/
        install -m 644 include/zloop.h $prefix/include/
        install -m 644 include/zmonitor.h $prefix/include/
        install -m 644 include/zmsg.h $prefix/include/
        install -m 644 include/zpoller.h $prefix/include/
        install -m 644 include/zproxy.h $prefix/include/
        install -m 644 include/zrex.h $prefix/include/
        install -m 644 include/zsock.h $prefix/include/
        install -m 644 include/zstr.h $prefix/include/
        install -m 644 include/zsys.h $prefix/include/
        install -m 644 include/zuuid.h $prefix/include/
    fi

	if [ -f /etc/rc.conf ]; then
		install -m 555 init/freebsd $sysconfdir/rc.d/inagent;
	elif $(stat --format=%N /proc/1/exe|grep -qs systemd); then
		if [ -d $prefix/usr/systemd/system ]; then
			install -m 644 init/systemd $prefix/lib/systemd/system/inagent.service
		elif [ -d /lib/systemd/system ]; then
			install -m 644 init/systemd /lib/systemd/system/inagent.service
		fi
	elif [ -f $sysconfdir/redhat-release ]; then
		install -m 755 init/redhat $sysconfdir/init.d/inagent
	elif [ -f $sysconfdir/debian_version ]; then
		install -m 755 init/debian $sysconfdir/init.d/inagent
	fi

    mkdir -p $sysconfdir/intecture
    sed "s~{{sysconfdir}}~$sysconfdir~" agent.json.tpl > agent.json
    install -m 644 agent.json $sysconfdir/intecture/

    install -m 755 inagent $prefix/bin
}

do_uninstall() {
	rm -f $prefix/bin/inagent \
		  $sysconfdir/intecture/agent.json \
		  /lib/systemd/system/inagent.service \
		  $prefix/lib/systemd/system/inagent.service \
		  $sysconfdir/init.d/inagent \
		  $sysconfdir/rc.d/inagent

	rmdir --ignore-fail-on-non-empty $sysconfdir/intecture
}

main() {
	if [ $# -eq 0 ]; then
		echo "Usage: installer.sh <install|uninstall>"
		exit 0
	fi

	case "$1" in
		install)
			do_install
			;;

		uninstall)
			do_uninstall
			;;

		*)
			echo "Unknown option $1"
			exit 1
			;;
	esac
}

main "$@"