#!/bin/sh
# based on https://gist.github.com/ryin/3106801

set -e

PREFIX=${PREFIX:-$HOME/local}
TMUX_TMP=${TMUX_TMP:-$HOME/tmux-tmp}
INSTALL=${INSTALL:-1}

TMUX_URI=http://downloads.sourceforge.net/tmux/tmux-1.9a.tar.gz
TMUX_SHA1=815264268e63c6c85fe8784e06a840883fcfc6a2
LIBEVENT_URI=https://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
LIBEVENT_SHA1=a586882bc93a208318c70fc7077ed8fca9862864
NCURSES_URI=http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
NCURSES_SHA1=3e042e5f2c7223bffdaac9646a533b8c758b65b5
ZSH_URI=http://sourceforge.net/projects/zsh/files/zsh/5.0.7/zsh-5.0.7.tar.gz
ZSH_SHA1=a77519d3a6c251c69b1f4924cacdac17cc8e6a9d

mkdir -p $PREFIX $TMUX_TMP
cd $TMUX_TMP

# download, extract, configure, and compile
# libevent #
wget --no-check-certificate --no-verbose -O libevent.tar.gz $LIBEVENT_URI
echo "$LIBEVENT_SHA1 *libevent.tar.gz" | sha1sum -c -
tar xzf libevent.tar.gz
cd libevent-2.0.22-stable
./configure --prefix=$PREFIX --disable-shared
make
if [ "$INSTALL" = 1 ]; then make install; fi
cd ..

# ncurses  #
wget --no-check-certificate --no-verbose -O ncurses.tar.gz $NCURSES_URI
echo "$NCURSES_SHA1 *ncurses.tar.gz" | sha1sum -c -
tar xzf ncurses.tar.gz
cd ncurses-5.9
./configure --prefix=$PREFIX CFLAGS="-fPIC"
make
if [ "$INSTALL" = 1 ]; then make install; fi
cd ..

# tmux     #
wget --no-check-certificate --no-verbose -O tmux.tar.gz $TMUX_URI
echo "$TMUX_SHA1 *tmux.tar.gz" | sha1sum -c -
tar xzf tmux.tar.gz
cd tmux-1.9a
./configure --prefix=$PREFIX CFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-L$PREFIX/lib -L$PREFIX/include/ncurses -L$PREFIX/include"
CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-static -L$PREFIX/include -L$PREFIX/include/ncurses -L$PREFIX/lib" make
if [ "$INSTALL" = 1 ]; then make install; fi
cd ..

# zsh
wget --no-check-certificate --no-verbose -O zsh.tar.gz $ZSH_URI
echo "$ZSH_SHA1 *zsh.tar.gz" | sha1sum -c -
tar xzf zsh.tar.gz
cd zsh-5.0.7
./configure --prefix=$PREFIX CFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-L$PREFIX/lib -L$PREFIX/include/ncurses -L$PREFIX/include"
CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-static -L$PREFIX/include -L$PREFIX/include/ncurses -L$PREFIX/lib" make
if [ "$INSTALL" = 1 ]; then make install; fi
cd ..

echo "$PREFIX/bin/tmux is now available. You can optionally add $PREFIX/bin to your PATH."

