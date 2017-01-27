#!/usr/bin/perl

=head1 NAME

entities.perl -- Encode characters according to DTABf.

=head1 INVOCATION

    $ perl entities.perl $INFILE > $OUTFILE

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

binmode( STDOUT, ':utf8' );

open( my $fh, '<:utf8', pop ) or die $!;
while( <$fh> ) {
    s{&#x([0-9a-f]+);}{ chr(hex($1)) }ige;
    s{([^\x{01}-\x{ff}])}{ sprintf "&#x%04X;", ord($1) }eg;
    print;
}

__END__
