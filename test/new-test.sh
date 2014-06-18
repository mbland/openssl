#!/bin/sh
#
# Generates a new unit/automated test stub.
#
# Usage:
# $ test/new-test.sh foobar
# Created foobar_test.c
#
# More information:
# https://wiki.openssl.org/index.php/How_To_Write_Unit_Tests_For_OpenSSL
#
# Author: Mike Bland (mbland@acm.org)
# Date:   2014-06-06
#
# ====================================================================
# Copyright (c) 2014 The OpenSSL Project.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
#
# 3. All advertising materials mentioning features or use of this
#    software must display the following acknowledgment:
#    "This product includes software developed by the OpenSSL Project
#    for use in the OpenSSL Toolkit. (http://www.OpenSSL.org/)"
#
# 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
#    endorse or promote products derived from this software without
#    prior written permission. For written permission, please contact
#    licensing@OpenSSL.org.
#
# 5. Products derived from this software may not be called "OpenSSL"
#    nor may "OpenSSL" appear in their names without prior written
#    permission of the OpenSSL Project.
#
# 6. Redistributions of any form whatsoever must retain the following
#    acknowledgment:
#    "This product includes software developed by the OpenSSL Project
#    for use in the OpenSSL Toolkit (http://www.OpenSSL.org/)"
#
# THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
# EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
# ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# ====================================================================

GIT_PREFIX=$(git rev-parse --show-prefix)
TEST_FILE="$1_test.c"

if test $? -ne 0 -o -z "$GIT_PREFIX"; then
	echo "This script must be run within a subdirectory of an OpenSSL"\
		"git repository."
	exit 1
elif test $# -ne 1; then
  echo "Please provide a name describing the code under test."
  echo "Usage: $0 foobar"
  exit 1
elif test -f $TEST_FILE; then
  echo "$1_test.c already exists; please remove or rename it before"\
    "running this script."
  exit 1
fi

NAME=$(echo $1 | tr '-' '_')
LOWER_NAME=$(echo $NAME | tr '[:upper:]' '[:lower:]')
UPPER_NAME=$(echo $NAME | tr '[:lower:]' '[:upper:]')

cat >$TEST_FILE <<EOF
/*
 * TODO: Add Description
 *
 * Author:  $(git config --get user.name) ($(git config --get user.email))
 * Date:    $(date +%Y-%m-%d)
 *
 * ====================================================================
 * Copyright (c) $(date +%Y) The OpenSSL Project.  All rights reserved.
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
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
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

#include "testutil.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if !defined(OPENSSL_SYS_WINDOWS)

typedef struct ${LOWER_NAME}_test_fixture
	{
	const char* test_case_name;
	} ${UPPER_NAME}_TEST_FIXTURE;

static ${UPPER_NAME}_TEST_FIXTURE set_up(const char* const test_case_name)
	{
	${UPPER_NAME}_TEST_FIXTURE fixture;
	int setup_ok = 1;
	memset(&fixture, 0, sizeof(fixture));
	fixture.test_case_name = test_case_name;

	fail:
	if (!setup_ok)
		{
		exit(EXIT_FAILURE);
		}
	return fixture;
	}

static void tear_down(${UPPER_NAME}_TEST_FIXTURE fixture)
	{
	}

static int execute(${UPPER_NAME}_TEST_FIXTURE fixture)
	{
	int result = 0;

	if (result != 0)
		{
		printf("** %s failed **\n--------\n", fixture.test_case_name);
		}
	return result;
	}

#define SETUP_${UPPER_NAME}_TEST_FIXTURE()\\
  SETUP_TEST_FIXTURE(${UPPER_NAME}_TEST_FIXTURE, set_up)

#define EXECUTE_${UPPER_NAME}_TEST()\\
  EXECUTE_TEST(execute, tear_down)

static int test_${LOWER_NAME}()
	{
	SETUP_${UPPER_NAME}_TEST_FIXTURE();
	EXECUTE_${UPPER_NAME}_TEST();
	}

#undef EXECUTE_${UPPER_NAME}_TEST
#undef SETUP_${UPPER_NAME}_TEST_FIXTURE

int main(int argc, char *argv[])
	{
	int num_failed;

	num_failed = test_${LOWER_NAME}() +
		0;

	if (num_failed != 0)
		{
		printf("%d test%s failed\n", num_failed, num_failed != 1 ? "s" : "");
		return EXIT_FAILURE;
		}
	return EXIT_SUCCESS;
	}

#else /* OPENSSL_NO_WINDOWS */

int main(int argc, char *argv[])
	{
		return EXIT_SUCCESS;
	}
#endif /* OPENSSL_NO_WINDOWS  */
EOF

echo "Created $TEST_FILE"
