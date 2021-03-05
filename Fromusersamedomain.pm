package Fromusersamedomain;
use Mail::SpamAssassin::Plugin;

our @ISA = qw(Mail::SpamAssassin::Plugin);

sub new {
    my ( $class, $mailsa ) = @_;

    # the usual perlobj boilerplate to create a subclass object
    $class = ref($class) || $class;
    my $self = $class->SUPER::new($mailsa);
    bless( $self, $class );

    $self->register_eval_rule("check_user_same_domain");

    # and return the new plugin object
    return $self;
}

sub check_user_same_domain {
    my ( $self, $msg ) = @_;
    my $from = lc( $msg->get('From:addr') );
    my ($user_from,$domain_from) = split('@', $from);

    Mail::SpamAssassin::Plugin::dbg("UserIsDomain: Comparing '$domain_from' =~ '$user_from'");

    if (   $user_from ne ''
        && $domain_from ne ''
        && $domain_from =~ $user_from )
    {
        return 1;
    }
    return 0;
}

# This ;1 is important
1;