#!/usr/bin/perl

# Copyright (C) 2017 Wolfgang Hotwagner <code@feedyourhead.at>       
#                                                                
# This file is part of mail2sms                                
# 
# This program is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation; either version 2 
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License          
# along with this program; if not, write to the 
# Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, 
# Boston, MA  02110-1301  USA 


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
