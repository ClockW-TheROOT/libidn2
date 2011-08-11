# Copyright (C) 2002-2011 Free Software Foundation, Inc.
#
# This file is free software, distributed under the terms of the GNU
# General Public License.  As a special exception to the GNU General
# Public License, this file may be distributed as part of a program
# that contains a configuration script generated by Autoconf, under
# the same distribution terms as the rest of that program.
#
# Generated by gnulib-tool.
#
# This file represents the specification of how gnulib-tool is used.
# It acts as a cache: It is written and read by gnulib-tool.
# In projects that use version control, this file is meant to be put under
# version control, like the configure.ac and various Makefile.am files.


# Specification in the form of a command-line invocation:
#   gnulib-tool --import --dir=. --local-dir=gl/override --lib=libgnu --source-base=gl --m4-base=gl/m4 --doc-base=doc --tests-base=tests --aux-dir=build-aux --lgpl=2 --no-conditional-dependencies --libtool --macro-prefix=gl --no-vc-files gendocs git-version-gen gnupload lib-symbol-versions lib-symbol-visibility maintainer-makefile manywarnings strchrnul strverscmp uniconv/u8-strconv-from-locale unictype/bidiclass-of unictype/category-M unictype/category-test unictype/joiningtype-of unictype/scripts uninorm/nfc uninorm/u32-normalize unistr/u32-to-u8 unistr/u8-to-u32 valgrind-tests

# Specification in the form of a few gnulib-tool.m4 macro invocations:
gl_LOCAL_DIR([gl/override])
gl_MODULES([
  gendocs
  git-version-gen
  gnupload
  lib-symbol-versions
  lib-symbol-visibility
  maintainer-makefile
  manywarnings
  strchrnul
  strverscmp
  uniconv/u8-strconv-from-locale
  unictype/bidiclass-of
  unictype/category-M
  unictype/category-test
  unictype/joiningtype-of
  unictype/scripts
  uninorm/nfc
  uninorm/u32-normalize
  unistr/u32-to-u8
  unistr/u8-to-u32
  valgrind-tests
])
gl_AVOID([])
gl_SOURCE_BASE([gl])
gl_M4_BASE([gl/m4])
gl_PO_BASE([])
gl_DOC_BASE([doc])
gl_TESTS_BASE([tests])
gl_LIB([libgnu])
gl_LGPL([2])
gl_MAKEFILE_NAME([])
gl_LIBTOOL
gl_MACRO_PREFIX([gl])
gl_PO_DOMAIN([])
gl_WITNESS_C_DOMAIN([])
gl_VC_FILES([false])
