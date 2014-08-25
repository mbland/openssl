#
# OpenSSL/tools/Makefile
#

DIR=	tools
TOP=	..
include $(TOP)/configure.mk
CC=	cc
INCLUDES= -I$(TOP) -I../../include
CFLAG=-g
MAKEFILE=	Makefile

CFLAGS= $(INCLUDES) $(CFLAG)

GENERAL=Makefile
TEST=
APPS= c_rehash
MISC_APPS= c_hash c_info c_issuer c_name

all:

install:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@for i in $(APPS) ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/bin/$$i.new; \
	chmod 755 $(INSTALL_PREFIX)$(INSTALLTOP)/bin/$$i.new; \
	mv -f $(INSTALL_PREFIX)$(INSTALLTOP)/bin/$$i.new $(INSTALL_PREFIX)$(INSTALLTOP)/bin/$$i ); \
	done;
	@for i in $(MISC_APPS) ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(OPENSSLDIR)/misc/$$i.new; \
	chmod 755 $(INSTALL_PREFIX)$(OPENSSLDIR)/misc/$$i.new; \
	mv -f $(INSTALL_PREFIX)$(OPENSSLDIR)/misc/$$i.new $(INSTALL_PREFIX)$(OPENSSLDIR)/misc/$$i ); \
	done;

files:
	$(PERL) $(TOP)/util/files.pl TOP=$(TOP) Makefile >> $(TOP)/MINFO

links:

lint:

tags:

errors:

dclean:
	rm -f c_rehash

clean:
	rm -f *.o *.d *.obj lib tags core .pure .nfs* *.old *.bak fluff

-include $(SRC:.c=.d)
