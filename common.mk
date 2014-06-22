# Common commands and rules shared between Makefiles
MAKEDEP_CMD=\
	@set -e; rm -f $@ $@.*; \
	$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

%.d: %.c
	$(MAKEDEP_CMD)

fips%.d: CFLAGS += -DOPENSSL_FIPS
