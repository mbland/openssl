#
# OpenSSL/crypto/md/Makefile
#

DIR=	hmac
TOP=	../..
include $(TOP)/configure.mk
INCLUDES=

CFLAGS= $(INCLUDES) $(CFLAG)

GENERAL=Makefile
TEST=hmactest.c
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=hmac.c hm_ameth.c hm_pmeth.c
LIBOBJ=hmac.o hm_ameth.o hm_pmeth.o

SRC= $(LIBSRC)

EXHEADER= hmac.h
HEADER=	$(EXHEADER)

ALL=    $(GENERAL) $(SRC) $(HEADER)

top: top_crypto_hmac
top_crypto_hmac:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all: all_crypto_hmac
all_crypto_hmac:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

files: files_crypto_hmac
files_crypto_hmac:
	$(PERL) $(TOP)/util/files.pl TOP=$(TOP) Makefile >> $(TOP)/MINFO

links: links_crypto_hmac
links_crypto_hmac:
	@$(PERL) $(TOP)/util/mklink.pl ../../include/openssl $(EXHEADER)
	@$(PERL) $(TOP)/util/mklink.pl ../../test $(TEST)
	@$(PERL) $(TOP)/util/mklink.pl ../../apps $(APPS)

install: install_crypto_hmac
install_crypto_hmac:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@headerlist="$(EXHEADER)"; for i in $$headerlist ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i; \
	chmod 644 $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i ); \
	done;

tags: tags_crypto_hmac
tags_crypto_hmac:
	ctags $(SRC)

tests: tests_crypto_hmac
tests_crypto_hmac:

lint: lint_crypto_hmac
lint_crypto_hmac:
	lint -DLINT $(INCLUDES) $(SRC)>fluff

dclean: dclean_crypto_hmac
dclean_crypto_hmac:

clean: clean_crypto_hmac
clean_crypto_hmac:
	rm -f *.o *.d *.obj lib tags core .pure .nfs* *.old *.bak fluff

-include $(SRC:.c=.d)
