#
# crypto/whrlpool/Makefile
#

DIR=	whrlpool
TOP=	../..
include $(TOP)/configure.mk
CC=	cc
CPP=	$(CC) -E
INCLUDES=
CFLAG=-g
MAKEFILE=	Makefile
AR=		ar r

WP_ASM_OBJ=wp_block.o

CFLAGS= $(INCLUDES) $(CFLAG)
ASFLAGS= $(INCLUDES) $(ASFLAG)
AFLAGS= $(ASFLAGS)

GENERAL=Makefile
TEST=wp_test.c
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=wp_dgst.c wp_block.c
LIBOBJ=wp_dgst.o $(WP_ASM_OBJ)

SRC= $(LIBSRC)

EXHEADER= whrlpool.h
HEADER= wp_locl.h $(EXHEADER)

ALL=    $(GENERAL) $(SRC) $(HEADER)

top:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

wp-mmx.s:	asm/wp-mmx.pl ../perlasm/x86asm.pl
	$(PERL) asm/wp-mmx.pl $(PERLASM_SCHEME) $(CFLAGS) $(PROCESSOR) > $@

wp-x86_64.s: asm/wp-x86_64.pl
	$(PERL) asm/wp-x86_64.pl $(PERLASM_SCHEME) > $@

$(LIBOBJ): $(LIBSRC)

files:
	$(PERL) $(TOP)/util/files.pl TOP=$(TOP) Makefile >> $(TOP)/MINFO

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

dclean:

clean:
	rm -f *.s *.o *.d *.obj lib tags core .pure .nfs* *.old *.bak fluff

-include $(SRC:.c=.d)
