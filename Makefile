CONFIGFILE := ''

all: build

deb:
	dpkg-buildpackage -rfakeroot -tc -sa -us -uc -I".directory" -I".git" -I"buildpackage.sh"