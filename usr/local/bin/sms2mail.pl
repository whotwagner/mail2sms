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



# IN20130307_171617_00_+4369912782084_00.txt

my $spooldir = '/var/spool/gammu/inbox/';
my $file = undef;
my $date = undef;
my $tel = undef;
my $subject = undef;

# CHANGE THE EMAIL-ADDREE HERE
my $recipient = 'dr@tardis';

opendir(D,$spooldir) || die "Can't open dir: $!\n";

while($file = readdir(D))
{

        if($file =~ m/IN(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d_\d{1,2}_(.*)_\d{1,2}.txt/g)
        {
                $date = "$1-$2-$3 $4:$5";
                $tel = $6;
                $subject = "SMS from $tel at $date";

                `cat $spooldir/$file | mutt -s "$subject" -- $recipient`;
                unlink "$spooldir/$file";
        }
}

closedir(D);
