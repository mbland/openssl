# Environment variables, functions, and aliases to help with OpenSSL unit
# testing.
#
# Usage:
#   $ . test_env.bash
#
# Author: Mike Bland (mbland@acm.org)
# Date:   2014-06-08
#
# new-test: Generates new test stubs
# ----------------------------------
# To generate a new unit/automated test stub, use new-test in the directory in
# which you want the new test to reside:
#
#   $ cd dir_for_new_test && new-test foobar
#
# This will create dir_for_new_test/foobar_test.c. To add this new test to the
# Makefiles, see the "Add Makefile Targets" and "Run make_depend" sections of:
#
#   http://wiki.openssl.org/index.php/How_To_Write_Unit_Tests_For_OpenSSL
#
# make-test: Builds and executes tests
# ------------------------------------
# make-test with no arguments will execute all the OpenSSL tests.
#
# make-test will also take arguments such that only the specified tests are
# built and executed:
#
#  $ make-test test_ca test_heartbeat
#
# CSCOPE SUPPORT
# --------------
# Cscope is a powerful C source code browser:
#
#   http://cscope.sourceforge.net/
#
# Once you have it installed, you can use:
#
# - make-cscope: Generates a new Cscope database ($CSCOPE_DB)
# - open-cscope: Opens the Cscope browser
#
# make-ctags: Generates a new Ctags cross-reference ($TAGS_FILE)
# --------------------------------------------------------------
# Ctags generates an index of symbols that many editors can use to quickly
# navigate the source code. Though many Unices ship with a version installed
# at /usr/bin/ctags, test_env.bash presumes that Exuberant Ctags is installed:
#
#   http://ctags.sourceforge.net/
#
# DEVELOPER BUILDS
# ----------------
# While one can begin developing tests using the standard OpenSSL
# configuration and 'make', before they are submitted, they must also pass
# using developer-specific flags and build tools.
#
# - dev-config: Runs $OPENSSL_ROOT/GitConfigure to configure the build using
#   developer flags
# - dev-make: Executes $OPENSSL_ROOT/GitMake
#
# Note that with dev-make, there is no need for a special alias like
# make-test, because all test targets can be specified directly to GitMake
# without the need for the TESTS make variable.
#
# For detailed information on developer builds, see the "Building and Running
# the Test" section of:
#
#   http://wiki.openssl.org/index.php/How_To_Write_Unit_Tests_For_OpenSSL
#
# MISCELLANEOUS
# -------------
# Some helper functions defined in this file may be of general use:
#
# - exec_in_root: executes and arbitrary command in $OPENSSL_ROOT
# - list-sources: lists all OpenSSL source files relative to $OPENSSL_ROOT

export OPENSSL_ROOT=$(git rev-parse --show-toplevel)
export TAGS_FILE=$OPENSSL_ROOT/tags
export CSCOPE_DB=$OPENSSL_ROOT/cscope.out

# Generates a new unit/automated test stub.
alias new-test="$OPENSSL_ROOT/test/new-test.sh"

# Builds and executes OpenSSL tests from any working directory.
# With no arguments, builds and executes all tests. With arguments, executes
# only the specified tests.
make-test() {
  if test $# -ne 0; then
    make -C $OPENSSL_ROOT test TESTS="$*"
  else
    make -C $OPENSSL_ROOT test
  fi
}

# Executes a command in $OPENSSL_ROOT
exec_in_root() {
  (cd $OPENSSL_ROOT && "$@")
}

_list-sources() {
  find $(find * -type d -depth 0 | egrep -v '(inc|out|tmp)\.')\
    -type f -name '*.[ch]'
}

# Lists all C source files in the OpenSSL code base.
# No symlinks are followed or returned.
list-sources() {
  exec_in_root _list-sources
}

# Builds a new $TAGS_FILE.
make-ctags() {
  list-sources | exec_in_root ctags -L- -f $TAGS_FILE
}

# Builds a new $CSCOPE_DB.
make-cscope() {
  exec_in_root cscope -b -f$CSCOPE_DB $(list-sources)
}

# Opens cscope without building a new $CSCOPE_DB.
open-cscope() {
  cscope -d -f$CSCOPE_DB -P$OPENSSL_ROOT
}

# Configures the build using developer flags.
dev-config() {
  exec_in_root ./GitConfigure debug-ben-debug-64-clang
}

# Builds using developer flags.
# Requires dev-config having already been run.
alias dev-make="$OPENSSL_ROOT/GitMake -C $OPENSSL_ROOT -j 2"
