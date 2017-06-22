#!/usr/bin/perl

print "Content-type: text/html\n\n";
print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">', "\n";
print '<html><body>';

my $query = undef;
my $number = undef;
my $msg = undef;

if($ENV{'REQUEST_METHOD'} eq 'POST')
{
        my $length = $ENV{'CONTENT_LENGTH'};
        my $tmp = undef;
        read(STDIN, $query, $length);
        my @arr = split(/\&/,$query);
        foreach(@arr)
        {
                $tmp = $_;
                if($tmp =~m/^Number=(.*)$/g)
                {
                        $number = $1;
                }

                if($tmp =~m/^msg=(.*)$/g)
                {
                        $msg = $1;
                }

                if(defined($msg) && defined($number))
                {
                        print "sending message...\n";
                        my $err = `sudo -u gammu /usr/bin/gammu-smsd-inject TEXT $number -text \"$msg\"`;

                }
        }
}

print "<br><br><a href=index.html>back</a>";

print '</body></html>';

exit 0;
