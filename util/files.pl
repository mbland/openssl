#!/usr/local/bin/perl
#
# used to generate the file MINFO for use by util/mk1mf.pl
# It is basically a list of all variables from the passed makefile
#

my %top, my %sym;

# Values specified on the command line take top precedence.
while ($ARGV[0] =~ /^([^\s=]+)\s*=\s*(.*)$/)
	{
	$top{$1} = $2;
	$sym{$1} = $2;
	shift;
	}

$top{'TOP'} ||
	die 'TOP= must be specified on the command line before any files.';

sub parse_var
	{
	my ($line, $input_fh) = @_;
	my $s="", my $b = "", my $o = "";
	chop $line;
	$line =~ s/#.*//;
	if ($line =~ /^([^\s=]+)\s*=\s*(.*)$/)
		{
		$o="";
		($s,$b)=($1,$2);
		for (;;)
			{
			if ($b =~ /\\$/)
				{
				chop($b);
				$o.=$b." ";
				$b=<$input_fh>;
				chop($b);
				}
			else
				{
				$o.=$b." ";
				last;
				}
			}
		$o =~ s/^\s+//;
		$o =~ s/\s+$//;
		$o =~ s/\s+/ /g;

		$o =~ s/\$[({]([^)}]+)[)}]/$top{$1} or $sym{$1}/ge;
		}
	else
		{
		undef $s;
		undef $o;
		}
	return ($s, $o);
	}

# Values from $(TOP)/configure.mk take precedence after command-line values.
$configure_mk_path = "$sym{'TOP'}/configure.mk";
open my $configure_mk, $configure_mk_path ||
	die "Couldn't open $configure_mk_path";
while (<$configure_mk>)
	{
	my ($s, $o) = parse_var $_, $configure_mk;
	if (defined $s) { $top{$s}=$o if !exists $top{$s}; }
	}
close $configure_mk;

while ($ARGV = shift)
	{
	open $makefile, $ARGV || die "Couldn't open $ARGV";
  while (<$makefile>)
		{
		my ($s, $o) = parse_var $_, $makefile;
		if (defined $s)
			{
			if (exists $top{$s}) { $sym{$s} = $top{$s}; }
			elsif (!exists $sym{$s}) { $sym{$s} = $o; }
			}
		}
	close $makefile;
	}

$pwd=`pwd`; chop($pwd);

if ($sym{'TOP'} eq ".")
	{
	$n=0;
	$dir=".";
	}
else	{
	$n=split(/\//,$sym{'TOP'});
	@_=split(/\//,$pwd);
	$z=$#_-$n+1;
	foreach $i ($z .. $#_) { $dir.=$_[$i]."/"; }
	chop($dir);
	}

print "RELATIVE_DIRECTORY=$dir\n";

foreach (sort keys %sym)
	{
	print "$_=$sym{$_}\n";
	}
print "RELATIVE_DIRECTORY=\n";
