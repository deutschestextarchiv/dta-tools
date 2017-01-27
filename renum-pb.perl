#!/usr/bin/perl

=head1 NAME

renum-pb.perl -- Adds and enumerates @facs values within C<< <pb> >> elements according to DTABf.

=head1 INVOCATION

    $ perl renum-pb.perl $INFILE > $OUTFILE

    $ perl renum-pb.perl --before=3 --after=8 $INFILE > $OUTFILE

        --before=N  [ page breaks to be inserted before the first <pb/> ]
        --after=N   [ page breaks to be inserted after the last <pb/> ]

=head1 VERSION

Version 0.01

=head1 SEE ALSO

L<http://www.deutschestextarchiv.de/doku/basisformat>.

=head1 AUTHOR

Frank Wiegand, C<< <wiegand@bbaw.de> >>

=head1 LICENSE AND COPYRIGHT

    "THE BEER-WARE LICENSE" (Revision 42):
    
    <wiegand@bbaw.de> wrote this file. As long as you retain this notice you
    can do whatever you want with this stuff. If we meet some day, and you think
    this stuff is worth it, you can buy me a beer in return.

=cut

use warnings;
use strict;

use Getopt::Long;

my $before = 0;
my $after  = 0;
GetOptions(
    'before=i' => \$before,
    'after=i'  => \$after,
) or die "error in command line arguments\n";

binmode( STDOUT, ':utf8' );

open( my $fh, '<:utf8', pop ) or die $!;
my $xml = do { local $/; <$fh> };
close $fh;

my $before_pbs = "<pb/>\n" x $before;
$xml =~ s{(<pb\b.*?/>)}{$before_pbs$1};

my $after_pbs = "<pb/>\n" x $after;
$xml =~ s{(</text>)}{$after_pbs$1}s;

my $n = 0;    
$xml =~ s{<pb\b(.*?)/>}{$n++; _renum_pb($n, $1)}gse;
print $xml;
    
sub _renum_pb {
    my ( $n, $attr ) = @_;
    no warnings 'uninitialized';
    $attr =~ s/facs=(["']).*?\1\s*//;
    my $ret = sprintf "<pb facs=\"#f%04d\" %s/>", $n, $attr;
    $ret =~ s/\s+/ /g;
    return $ret;
}

__END__
