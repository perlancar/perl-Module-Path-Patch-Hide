package Module::Path::Patch::Hide;

# DATE
# VERSION

use 5.010001;
use strict;
no warnings;

use Module::Patch 0.12 qw();
use base qw(Module::Patch);

our %config;

my $w_module_path = sub {
    my $ctx  = shift;
    my $orig = $ctx->{orig};

    my @mods = split /\s*[;,]\s*/, $config{-module};

    if (grep { $_[0] eq $_ } @mods) {
        return undef;
    } else {
        return $orig->(@_);
    }
};

sub patch_data {
    return {
        v => 3,
        config => {
            -module => {
                summary => 'A string containing semicolon-separated list '.
                    'of module names to hide',
                schema => 'str*',
            },
        },
        patches => [
            {
                action => 'wrap',
                sub_name => 'module_path',
                code => $w_module_path,
            },
        ],
    };
}

1;
# ABSTRACT: Hide some modules from Module::Path

=head1 SYNOPSIS

 % PERL5OPT=-MModule::Path::Patch::Hide=-module,'Foo::Bar;Baz' app.pl

In the above example C<app.pl> will think that C<Foo::Bar> and C<Baz> are not
installed even though they might actually be installed.


=head1 DESCRIPTION

This module can be used to simulate the absence of certain modules. This only
works if the application uses L<Module::Path>'s C<module_path()> to
check the availability of modules.

This module works by patching C<module_path()> to return empty result if user
asks the modules that happen to be hidden.


=head1 append:SEE ALSO

L<Module::Path::More::Patch::Hide>

If the application checks he availability of modules by actually trying to
C<require()> them, you can try: L<lib::filter>, L<lib::disallow>.

=cut
