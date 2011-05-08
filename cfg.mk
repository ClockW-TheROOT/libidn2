# Copyright (C) 2011 Simon Josefsson

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CFGFLAGS ?= --enable-gtk-doc --enable-gtk-doc-pdf --enable-gcc-warnings

ifeq ($(.DEFAULT_GOAL),abort-due-to-no-makefile)
.DEFAULT_GOAL := buildit
endif

local-checks-to-skip += sc_unmarked_diagnostics sc_bindtextdomain # Re-add when we have translation
local-checks-to-skip += sc_immutable_NEWS
local-checks-to-skip += sc_prohibit_strcmp
local-checks-to-skip += sc_copyright_check

# Ignore gnulib files.
VC_LIST_ALWAYS_EXCLUDE_REGEX = ^(maint.mk|src/gl/.*|gl/.*|m4/.*)$$

# Explicit syntax-check exceptions.
exclude_file_name_regexp--sc_program_name = ^(tests|examples)/.*\.c$$
exclude_file_name_regexp--sc_prohibit_empty_lines_at_EOF = ^doc/reference/version.xml.in$$
exclude_file_name_regexp--sc_trailing_blank = ^(tests/IdnaTest.(txt|inc))|(doc/gdoc)$$
exclude_file_name_regexp--sc_require_config_h = ^examples/.*\.c$$
exclude_file_name_regexp--sc_require_config_h_first = ^examples/.*\.c$$

update-copyright-env = UPDATE_COPYRIGHT_HOLDER="Simon Josefsson"

INDENT_SOURCES = \
	bidi.c \
	bidi.h \
	context.c \
	context.h \
	data.h \
	error.c \
	free.c \
	idn2.h.in \
	idna.c \
	idna.h \
	lookup.c \
	punycode.h \
	register.c \
	src/blurbs.h \
	src/idn2.c \
	tables.c \
	tables.h \
	version.c

doc/Makefile.gdoc:
	printf "gdoc_MANS =\ngdoc_TEXINFOS =\n" > doc/Makefile.gdoc

buildit: doc/Makefile.gdoc
	test -f configure || autoreconf --force --install
	test -f Makefile || ./configure $(CFGFLAGS)
	make

glimport:
	gnulib-tool --add-import

# Release

htmldir = ../www-libidn/libidn2

coverage-my:
	ln -s . gl/uniconv/uniconv
	ln -s . gl/unictype/unictype
	ln -s . gl/uninorm/uninorm
	ln -s . gl/unistr/unistr
	$(MAKE) coverage

coverage-copy:
	rm -fv `find $(htmldir)/coverage -type f | grep -v CVS`
	mkdir -p $(htmldir)/coverage/
	cp -rv $(COVERAGE_OUT)/* $(htmldir)/coverage/

coverage-upload:
	cd $(htmldir) && \
	find coverage -type d -! -name CVS -! -name '.' \
		-exec cvs add {} \; && \
	find coverage -type d -! -name CVS -! -name '.' \
		-exec sh -c "cvs add -kb {}/*.png" \; && \
	find coverage -type d -! -name CVS -! -name '.' \
		-exec sh -c "cvs add {}/*.html" \; && \
	cvs add coverage/libidn2.info coverage/gcov.css || true && \
	cvs commit -m "Update." coverage

clang:
	make clean
	scan-build ./configure
	rm -rf scan.tmp
	scan-build -o scan.tmp make

clang-copy:
	rm -fv `find $(htmldir)/clang-analyzer -type f | grep -v CVS`
	mkdir -p $(htmldir)/clang-analyzer/
	cp -rv scan.tmp/*/* $(htmldir)/clang-analyzer/

clang-upload:
	cd $(htmldir) && \
		cvs add clang-analyzer || true && \
		cvs add clang-analyzer/*.css clang-analyzer/*.js \
			clang-analyzer/*.html || true && \
		cvs commit -m "Update." clang-analyzer

ChangeLog:
	git2cl > ChangeLog

tarball:
	! git tag -l $(PACKAGE)-$(VERSION) | grep $(PACKAGE) > /dev/null
	$(MAKE) ChangeLog distcheck

gendoc-copy:
	cd doc && ../build-aux/gendocs.sh \
		--html "--css-include=texinfo.css" \
		-o ../$(htmldir)/manual/ $(PACKAGE) "$(PACKAGE_NAME)"

gendoc-upload:
	cd $(htmldir) && \
		cvs add manual || true && \
		cvs add manual/html_node || true && \
		cvs add -kb manual/*.gz manual/*.pdf || true && \
		cvs add manual/*.txt manual/*.html \
			manual/html_node/*.html || true && \
		cvs commit -m "Update." manual/

gtkdoc-copy:
	mkdir -p $(htmldir)/reference/
	cp -v doc/reference/$(PACKAGE).pdf \
		doc/reference/html/*.html \
		doc/reference/html/*.png \
		doc/reference/html/*.devhelp \
		doc/reference/html/*.css \
		$(htmldir)/reference/

gtkdoc-upload:
	cd $(htmldir) && \
		cvs add reference || true && \
		cvs add -kb reference/*.png reference/*.pdf || true && \
		cvs add reference/*.html reference/*.css \
			reference/*.devhelp || true && \
		cvs commit -m "Update." reference/

source:
	-git commit -m Generated. ChangeLog
	git tag -u b565716f! -m $(VERSION) $(PACKAGE)-$(VERSION)

release-check: syntax-check tarball gendoc-copy gtkdoc-copy coverage-my coverage-copy clang clang-copy

release-upload-www: gendoc-upload gtkdoc-upload coverage-upload clang-upload

release-upload-ftp:
	git push
	git push --tags
	build-aux/gnupload --to alpha.gnu.org:libidn $(distdir).tar.gz
	cp $(distdir).tar.gz $(distdir).tar.gz.sig ../releases/$(PACKAGE)/

release: release-check release-upload-www source release-upload-ftp
