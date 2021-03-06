#
# This builds an OpenWrt package
# (VoCore, Onion Omega, Carambola, WRTnode, TL-MR3020 ...)
#

.PHONY: clean all

all: dist/blynk.min.js dist/blynk-library-js.ipk

dist:
	mkdir -p dist

dist/blynk-library-js.ipk: dist
	rm -rf ipk
	mkdir -p ipk/usr/local/lib/node_modules/blynk-library
	cp -r blynk-node.js blynk.js *.json certs bin ipk/usr/local/lib/node_modules/blynk-library
	mkdir -p ipk/bin
	ln -s /usr/local/lib/node_modules/blynk-library/bin/blynk.js ipk/bin/blynk.js
	ln -s /usr/local/lib/node_modules/blynk-library/bin/blynk-ctrl.js ipk/bin/blynk-ctrl.js
	tar czvf control.tar.gz control
	cd ipk; tar czvf ../data.tar.gz .; cd ..
	echo 2.0 > debian-binary
	ar r dist/blynk-library-js.ipk control.tar.gz data.tar.gz  debian-binary
	rm -rf ipk
	rm -f control.tar.gz data.tar.gz debian-binary

dist/blynk.js: dist
	./node_modules/.bin/browserify . --standalone Blynk -o dist/blynk.js

dist/blynk.min.js: dist dist/blynk.js
	./node_modules/.bin/uglifyjs -o dist/blynk.min.js dist/blynk.js

clean:
	rm -rf dist
