#! /usr/bin/perl
#
# Prints a subset of test targets for distributed test execution.
#
# Usage:
# $ perl test/get-test-shard.pl test/Makefile --num_shards 10 --shard 0
#
# Author: Mike Bland (mbland@acm.org)
# Date:   2014-06-27
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

use strict;
use integer;
use Getopt::Long;

my $num_shards;
my $shard;

GetOptions(
	'num_shards=i' => \$num_shards,
	'shard=i' => \$shard);

sub usage
	{
	print "Usage: perl $0 path/to/Makefile --num_shards N --shard M\n";
	exit(1);
	}

if (! defined $num_shards || ! defined $shard)
	{
	print "Both --num_shards and --shards must be specified.\n";
	usage
	}
elsif ($num_shards < 1)
	{
	print "--num_shards must be greater than zero.\n";
	usage
	}
elsif ($shard < 0 || $shard >= $num_shards)
	{
	print "--shard must be in the range [0, --num_shards)\n";
	usage
	}

my $makefile = shift(@ARGV);

if (!$makefile)
	{
	print "Makefile not specified\n";
	usage;
	}
elsif (scalar @ARGV != 0)
	{
  print "Extra command line arguments not allowed: @ARGV\n";
	usage
	}
elsif (! -f $makefile)
	{
	print "Cannot access $makefile\n";
	usage
	}

my $make_cmd = "/usr/bin/make -pn -f $makefile alltests";
my @test_targets;

open(MAKE_ALLTESTS,  "$make_cmd 2>&1 |") || die "Error executing $make_cmd";

while (<MAKE_ALLTESTS>)
	{
	chomp;
	if (/^alltests:/)
		{
		@test_targets = split(/ /);
		shift(@test_targets);
		}
	}

close(MAKE_ALLTESTS);

my $num_targets = @test_targets;

if ($num_targets == 0)
	{
	print "No test targets found in $makefile\n";
	exit(1);
	}

my $shard_size = $num_targets / $num_shards;
my $remainder = $num_targets % $num_shards;
my $shard_begin = 0;
my $shard_end = 0;

if ($shard < $remainder)
	{
	$shard_size++;
	}
else
	{
	$shard_begin += $remainder;
	}

$shard_begin += $shard * $shard_size;
my $shard_end = $shard_begin + $shard_size - 1;

print "@test_targets[$shard_begin .. $shard_end]\n";
