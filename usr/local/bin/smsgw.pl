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


use Log::Log4perl;
use Getopt::Std;

my %options=();
getopts("r:f:h", \%options);

my $logconf = q(
log4perl.rootLogger                = DEBUG,Logfile
log4perl.appender.Logfile          = Log::Log4perl::Appender::File
log4perl.appender.Logfile.filename = /var/log/smsgw.log
log4perl.appender.Logfile.layout   = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Logfile.layout.ConversionPattern = [%r] %F %L %m%n
log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
log4perl.appender.Screen.stderr  = 0
log4perl.appender.Screen.layout = Log::Log4perl::Layout::SimpleLayout
);

my $line = undef;
my $mailstring = undef;
my $from = undef;
my $to = undef;
my $subject = undef;
my $out = 0;

Log::Log4perl::init( \$logconf);
my $log = Log::Log4perl::get_logger("smsgw");

if($options{h})
{
        $log->logdie("usage: smsgw.pl -f  -r ");
}

$log->logdie("-f option is missing use -h for help") if not defined($options{f});
$log->logdie("-r option is missing use -h for help") if not defined($options{r});

$from = $options{f};
$to = $options{r};

$log->info("Mail kommt rein..");

while(defined($line = <STDIN> ))
{
	$log->debug("LINE: \"$line\"");

        if($line =~ m/^subject: (.*)\n/i) { $subject = $1; }

	if( ($line eq "\n") && ($out != 1) )
        {
                $log->info("NOW IT MESSAGE-PART");
                $log->info("BECAUSE: ..$line..");
                $out = 1;
        }
        else
        {
                $mailstring .= $line if($out == 1);
        }
}

$log->info("FROM: $from");
$log->info("TO: $to");
$log->info("SUBJECT: $subject");
$log->info("MAIL: $mailstring");

my $telnumber = 0;
if($to =~ m/^(\d+)@/)
{
        $telnumber = $1;
}

if($telnumber == 0)
{
        $log->logdie("not a number-format!");
}

$log->info("NUMBER: $telnumber");

my $smsstring = "sudo -u gammu gammu-smsd-inject TEXT $telnumber -text \"$mailstring\"";
$log->info("$smsstring");

my $output = `$smsstring`;
$log->warn("$output");
