#
# OpenSSL/crypto/stack/Makefile
#

DIR=	stack
TOP=	../..
include $(TOP)/configure.mk
INCLUDES=

CFLAGS= $(INCLUDES) $(CFLAG)

GENERAL=Makefile
TEST=
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=stack.c
LIBOBJ=stack.o

SRC= $(LIBSRC)

EXHEADER= stack.h safestack.h
HEADER=	$(EXHEADER)

ALL=    $(GENERAL) $(SRC) $(HEADER)

top: top_crypto_stack
top_crypto_stack:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all: all_crypto_stack
all_crypto_stack:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

files: files_crypto_stack
files_crypto_stack:
	$(PERL) $(TOP)/util/files.pl TOP=$(TOP) Makefile >> $(TOP)/MINFO

links: links_crypto_stack
links_crypto_stack:
	@$(PERL) $(TOP)/util/mklink.pl ../../include/openssl $(EXHEADER)
	@$(PERL) $(TOP)/util/mklink.pl ../../test $(TEST)
	@$(PERL) $(TOP)/util/mklink.pl ../../apps $(APPS)

install: install_crypto_stack
install_crypto_stack:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@headerlist="$(EXHEADER)"; for i in $$headerlist ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i; \
	chmod 644 $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i ); \
	done;

tags: tags_crypto_stack
tags_crypto_stack:
	ctags $(SRC)

tests: tests_crypto_stack
tests_crypto_stack:

lint: lint_crypto_stack
lint_crypto_stack:
	lint -DLINT $(INCLUDES) $(SRC)>fluff

dclean: dclean_crypto_stack
dclean_crypto_stack:

clean: clean_crypto_stack
clean_crypto_stack:
	rm -f *.o *.d *.obj lib tags core .pure .nfs* *.old *.bak fluff

-include $(SRC:.c=.d)
