include common.mk

ifneq (,$(findstring crypto,$(DIRS)))
#include crypto/build.mk
#include crypto/aes/build.mk
#include crypto/asn1/build.mk
#include crypto/bf/build.mk
#include crypto/bio/build.mk
#include crypto/bn/build.mk
#include crypto/buffer/build.mk
#include crypto/camellia/build.mk
#include crypto/cast/build.mk
#include crypto/cmac/build.mk
#include crypto/cms/build.mk
#include crypto/comp/build.mk
#include crypto/conf/build.mk
#include crypto/des/build.mk
#include crypto/dh/build.mk
#include crypto/dsa/build.mk
#include crypto/dso/build.mk
#include crypto/ec/build.mk
#include crypto/ecdh/build.mk
#include crypto/ecdsa/build.mk
#include crypto/engine/build.mk
#include crypto/err/build.mk
#include crypto/evp/build.mk
#include crypto/hmac/build.mk
#include crypto/idea/build.mk
#include crypto/jpake/build.mk
#include crypto/krb5/build.mk
#include crypto/lhash/build.mk
#include crypto/md2/build.mk
#include crypto/md4/build.mk
#include crypto/md5/build.mk
#include crypto/mdc2/build.mk
#include crypto/modes/build.mk
#include crypto/objects/build.mk
#include crypto/ocsp/build.mk
#include crypto/pem/build.mk
#include crypto/pkcs12/build.mk
#include crypto/pkcs7/build.mk
#include crypto/pqueue/build.mk
#include crypto/rand/build.mk
#include crypto/rc2/build.mk
#include crypto/rc4/build.mk
#include crypto/rc5/build.mk
#include crypto/ripemd/build.mk
#include crypto/rsa/build.mk
#include crypto/seed/build.mk
#include crypto/sha/build.mk
#include crypto/srp/build.mk
#include crypto/stack/build.mk
#include crypto/store/build.mk
#include crypto/ts/build.mk
#include crypto/txt_db/build.mk
#include crypto/ui/build.mk
#include crypto/whrlpool/build.mk
#include crypto/x509/build.mk
#include crypto/x509v3/build.mk
endif

ifneq (,$(findstring fips,$(DIRS)))
#include fips/aes/build.mk
#include fips/build.mk
#include fips/cmac/build.mk
#include fips/des/build.mk
#include fips/dh/build.mk
#include fips/dsa/build.mk
#include fips/ecdh/build.mk
#include fips/ecdsa/build.mk
#include fips/hmac/build.mk
#include fips/rand/build.mk
#include fips/rsa/build.mk
#include fips/sha/build.mk
#include fips/utl/build.mk
endif

ifneq (,$(findstring ssl,$(DIRS)))
#include ssl/build.mk
endif

ifneq (,$(findstring engines,$(DIRS)))
#include engines/build.mk
#include engines/ccgost/build.mk
endif

ifneq (,$(findstring apps,$(DIRS)))
#include apps/build.mk
endif

ifneq (,$(findstring test,$(DIRS)))
#include test/build.mk
endif

ifneq (,$(findstring tools,$(DIRS)))
#include tools/build.mk
endif

#include demos/bio/build.mk
#include demos/easy_tls/build.mk
#include demos/eay/build.mk
#include demos/engines/cluster_labs/build.mk
#include demos/engines/ibmca/build.mk
#include demos/engines/rsaref/build.mk
#include demos/engines/zencod/build.mk
#include demos/err/build.mk
#include demos/maurice/build.mk
#include demos/prime/build.mk
#include demos/sign/build.mk
#include demos/state_machine/build.mk
#include demos/tunala/build.mk
