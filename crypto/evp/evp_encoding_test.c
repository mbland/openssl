/*
 * Tests for basic encoding/decoding functions.
 *
 * Author:  Mike Bland (mbland@acm.org)
 * Date:    2014-06-19
 *
 * ====================================================================
 * Copyright (c) 2014 The OpenSSL Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit. (http://www.OpenSSL.org/)"
 *
 * 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
 *    endorse or promote products derived from this software without
 *    prior written permission. For written permission, please contact
 *    licensing@OpenSSL.org.
 *
 * 5. Products derived from this software may not be called "OpenSSL"
 *    nor may "OpenSSL" appear in their names without prior written
 *    permission of the OpenSSL Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit (http://www.OpenSSL.org/)"
 *
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */

#include <openssl/evp.h>
#include "testutil.h"
#include <openssl/crypto.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if !defined(OPENSSL_SYS_WINDOWS)

typedef struct encode_block_test_fixture
	{
	const char* test_case_name;
	const char* input_buf;
	int expected_bytes_encoded;
	const char* expected_result;
	} ENCODE_BLOCK_TEST_FIXTURE;

static ENCODE_BLOCK_TEST_FIXTURE set_up_encode_block(
	const char* const test_case_name)
	{
	ENCODE_BLOCK_TEST_FIXTURE fixture;
	memset(&fixture, 0, sizeof(fixture));
	fixture.test_case_name = test_case_name;
	return fixture;
	}

static void tear_down_encode_block(ENCODE_BLOCK_TEST_FIXTURE fixture)
	{
	}

static int execute_encode_block(ENCODE_BLOCK_TEST_FIXTURE fixture)
	{
	int result = 0;
	/* Plus one byte for NUL */
	unsigned char* result_buf =
		OPENSSL_malloc(fixture.expected_bytes_encoded + 1);
	int bytes_encoded = EVP_EncodeBlock(result_buf,
		(const unsigned char*)fixture.input_buf,
		strlen(fixture.input_buf));

	if (bytes_encoded != fixture.expected_bytes_encoded)
		{
		printf("%s failed:\n  expected bytes encoded: %d\n"
			"  actual bytes encoded: %d\n",
			fixture.test_case_name, fixture.expected_bytes_encoded,
			bytes_encoded);
		result = 1;
		}
	if (strcmp(fixture.expected_result, (const char*)result_buf) != 0)
		{
		printf("%s failed:\n  expected encoded buffer: %s\n"
			"  actual encoded buffer: %s\n",
			fixture.test_case_name, fixture.expected_result,
			result_buf);
		result = 1;
		}

	OPENSSL_free(result_buf);
	return result;
	}

#define SETUP_ENCODE_BLOCK_TEST_FIXTURE()\
	SETUP_TEST_FIXTURE(ENCODE_BLOCK_TEST_FIXTURE, set_up_encode_block)

#define EXECUTE_ENCODE_BLOCK_TEST()\
	EXECUTE_TEST(execute_encode_block, tear_down_encode_block)

DECLARE_TEST_REGISTRY()

TEST(encode_empty_block)
	{
	SETUP_ENCODE_BLOCK_TEST_FIXTURE();
	fixture.input_buf = "";
	fixture.expected_bytes_encoded = 0;
	fixture.expected_result = "";
	EXECUTE_ENCODE_BLOCK_TEST();
	}

TEST(encode_single_character_block)
	{
	SETUP_ENCODE_BLOCK_TEST_FIXTURE();
	fixture.input_buf = "M";
	fixture.expected_bytes_encoded = 4;
	fixture.expected_result = "TQ==";
	EXECUTE_ENCODE_BLOCK_TEST();
	}

TEST(encode_two_character_block)
	{
	SETUP_ENCODE_BLOCK_TEST_FIXTURE();
	fixture.input_buf = "MS";
	fixture.expected_bytes_encoded = 4;
	fixture.expected_result = "TVM=";
	EXECUTE_ENCODE_BLOCK_TEST();
	}

TEST(encode_three_character_block)
	{
	SETUP_ENCODE_BLOCK_TEST_FIXTURE();
	fixture.input_buf = "MSB";
	fixture.expected_bytes_encoded = 4;
	fixture.expected_result = "TVNC";
	EXECUTE_ENCODE_BLOCK_TEST();
	}

TEST(encode_four_character_block)
	{
	SETUP_ENCODE_BLOCK_TEST_FIXTURE();
	fixture.input_buf = "MSB2";
	fixture.expected_bytes_encoded = 8;
	fixture.expected_result = "TVNCMg==";
	EXECUTE_ENCODE_BLOCK_TEST();
	}

#undef EXECUTE_ENCODE_BLOCK_TEST
#undef SETUP_ENCODE_BLOCK_TEST_FIXTURE

int main(int argc, char *argv[])
	{
	int result = 0;

	ADD_TEST(encode_empty_block);
	ADD_TEST(encode_single_character_block);
	ADD_TEST(encode_two_character_block);
	ADD_TEST(encode_three_character_block);
	ADD_TEST(encode_four_character_block);

	MemCheck_start();
	result = RUN_TESTS(argv[0]);
	MemCheck_stop();
	return result;
	}

#else /* OPENSSL_NO_WINDOWS */

int main(int argc, char *argv[])
	{
		return EXIT_SUCCESS;
	}
#endif /* OPENSSL_NO_WINDOWS  */
