#
# OpenSSL/crypto/md5/build.mk
#

DIR=    md5
CPP=    $(CC) -E
INCLUDES=-I.. -I$(TOP) -I../../include
MAKEFILE=       Makefile


CFLAGS= $(INCLUDES) $(CFLAG)
ASFLAGS= $(INCLUDES) $(ASFLAG)
AFLAGS= $(ASFLAGS)

GENERAL=Makefile
TEST=md5test.c
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=md5_dgst.c md5_one.c
LIBOBJ=md5_dgst.o md5_one.o $(MD5_ASM_OBJ)

SRC= $(LIBSRC)

EXHEADER= md5.h
HEADER= md5_locl.h $(EXHEADER)

ALL=    $(GENERAL) $(SRC) $(HEADER)

top:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all:    lib

lib:    $(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

md5-586.s:	asm/md5-586.pl ../perlasm/x86asm.pl
	$(PERL) asm/md5-586.pl $(PERLASM_SCHEME) $(CFLAGS) > $@

md5-x86_64.s:	asm/md5-x86_64.pl
	$(PERL) asm/md5-x86_64.pl $(PERLASM_SCHEME) > $@

md5-ia64.s: asm/md5-ia64.S
	$(CC) $(CFLAGS) -E asm/md5-ia64.S | \
	$(PERL) -ne 's/;\s+/;\n/g; print;' > $@

md5-sparcv9.S:	asm/md5-sparcv9.pl
	$(PERL) asm/md5-sparcv9.pl $@ $(CFLAGS)

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
