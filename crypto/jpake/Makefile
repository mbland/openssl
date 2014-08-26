DIR=jpake
TOP=../..
include $(TOP)/configure.mk

CFLAGS= $(INCLUDES) $(CFLAG)

LIB=$(TOP)/libcrypto.a
LIBOBJ=jpake.o jpake_err.o
LIBSRC=jpake.c jpake_err.c
SRC= $(LIBSRC)

EXHEADER=jpake.h
TEST=jpaketest.c

top: top_crypto_jpake
top_crypto_jpake:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all: all_crypto_jpake
all_crypto_jpake:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

links: links_crypto_jpake
links_crypto_jpake:
	@$(PERL) $(TOP)/util/mklink.pl ../../include/openssl $(EXHEADER)
	@$(PERL) $(TOP)/util/mklink.pl ../../test $(TEST)

install: install_crypto_jpake
install_crypto_jpake:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@headerlist="$(EXHEADER)"; for i in $$headerlist ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i; \
	chmod 644 $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i ); \
	done;

dclean: dclean_crypto_jpake
dclean_crypto_jpake:

clean: clean_crypto_jpake
clean_crypto_jpake:
	rm -f *.s *.o *.d *.obj des lib tags core .pure .nfs* *.old *.bak fluff

-include $(SRC:.c=.d)
