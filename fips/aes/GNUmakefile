#
# OpenSSL/fips/aes/GNUmakefile
#

include fips/aes/Makefile
-include $(SRC_fips_aes:.c=.d)

fips/aes/%.o: fips/aes/%.c
	$(CC) $(CFLAGS_fips_aes) $(CPPFLAGS) -c -o $@ $<
