#
# OpenSSL/crypto/rc5/build.mk
#

DIR=	rc5
TOP=	../..
CC=	cc
CPP=	$(CC) -E
INCLUDES=
CFLAG=-g
MAKEFILE=	Makefile
AR=		ar r

RC5_ENC=		rc5_enc.o

CFLAGS= $(INCLUDES) $(CFLAG)
ASFLAGS= $(INCLUDES) $(ASFLAG)
AFLAGS= $(ASFLAGS)

GENERAL=Makefile
TEST=rc5test.c
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=rc5_skey.c rc5_ecb.c rc5_enc.c rc5cfb64.c rc5ofb64.c 
LIBOBJ=rc5_skey.o rc5_ecb.o $(RC5_ENC) rc5cfb64.o rc5ofb64.o

SRC= $(LIBSRC)

EXHEADER= rc5.h
HEADER=	rc5_locl.h $(EXHEADER)

ALL=    $(GENERAL) $(SRC) $(HEADER)

top:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

rc5-586.s: asm/rc5-586.pl ../perlasm/x86asm.pl ../perlasm/cbc.pl
	$(PERL) asm/rc5-586.pl $(PERLASM_SCHEME) $(CFLAGS) > $@

files:
	$(PERL) $(TOP)/util/files.pl build.mk >> $(TOP)/MINFO

links:
	@$(PERL) $(TOP)/util/mklink.pl ../../include/openssl $(EXHEADER)
	@$(PERL) $(TOP)/util/mklink.pl ../../test $(TEST)
	@$(PERL) $(TOP)/util/mklink.pl ../../apps $(APPS)

install:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@headerlist="$(EXHEADER)"; for i in $$headerlist ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i; \
	chmod 644 $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i ); \
	done;

tags:
	ctags $(SRC)

tests:

lint:
	lint -DLINT $(INCLUDES) $(SRC)>fluff

depend:
	@[ -n "$(MAKEDEPEND)" ] # should be set by upper Makefile...
	$(MAKEDEPEND) -- $(CFLAG) $(INCLUDES) $(DEPFLAG) -- $(PROGS) $(LIBSRC)

dclean:
	$(PERL) -pe 'if (/^# DO NOT DELETE THIS LINE/) {print; exit(0);}' $(MAKEFILE) >Makefile.new
	mv -f Makefile.new $(MAKEFILE)

clean:
	rm -f *.s *.o *.d *.obj lib tags core .pure .nfs* *.old *.bak fluff


-include $(patsubst %.c,%.d,$(SRC))

# DO NOT DELETE THIS LINE -- make depend depends on it.
