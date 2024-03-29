#!/usr/bin/perl
# --
# xml2docbook.pl - script that generates docbook xml out of the SysConfig parameters of OTRS for inclusion in the admin manual
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin) . "/../";
use lib dirname($RealBin) . "/../Kernel/cpan-lib";

use Getopt::Std;

use Kernel::System::ObjectManager;

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-xml2docbook.pl',
    },
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# get options
my %Opts = ();
getopt( 'l', \%Opts );

if ( !$Opts{l} ) {
    die "Need -l <Language>\n";
}

my $UserLang = $Opts{l};

print <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE appendix PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
    "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">

<!-- Note: this file is autogenerated by xml2docbook.pl -->

EOF

if ( $UserLang eq 'de' ) {
    print "<appendix id=\"ConfigReference\"><title>Referenz der Konfigurationsoptionen</title>\n";
}
else {
    print "<appendix id=\"ConfigReference\"><title>Configuration Options Reference</title>\n";
}

my %List = $SysConfigObject->ConfigGroupList();
for my $Group ( sort { $a cmp $b } keys %List ) {
    my %SubList = $SysConfigObject->ConfigSubGroupList( Name => $Group );
    print "<section id=\"ConfigReference_$Group\"><title>$Group</title>\n";
    for my $SubGroup ( sort keys %SubList ) {
        print "<section id=\"ConfigReference_$Group:$SubGroup\" role=\"NotInToc\"><title>$SubGroup</title>\n";
        my @List = $SysConfigObject->ConfigSubGroupConfigItemList(
            Group    => $Group,
            SubGroup => $SubGroup
        );
        for my $Name (@List) {
            my %Item = $SysConfigObject->ConfigItemGet( Name => $Name );
            my $Link = $Name;
            $Link =~ s/###/_/g;
            $Link =~ s/\///g;
            print <<EOF;
<section id="ConfigReference_$Group:$SubGroup:$Link" role="NotInToc"><title>$Name</title>
<informaltable>
    <tgroup cols="2">
        <colspec colwidth="1*"/>
        <colspec colwidth="3*"/>
        <tbody>
EOF

            #Description
            my %HashLang;
            for my $Index ( 1 ... $#{ $Item{Description} } ) {
                $Item{Description}[$Index]{Lang} ||= 'en';
                $HashLang{ $Item{Description}[$Index]{Lang} } = $Item{Description}[$Index]{Content};
            }
            my $Description;

            # Description in User Language
            if ( defined $HashLang{$UserLang} ) {
                $Description = $HashLang{$UserLang};
            }

            # Description in Default Language
            else {
                $Description = $HashLang{'en'};
            }
            $Description =~ s/&/&amp;/g;
            $Description =~ s/</&lt;/g;
            $Description =~ s/>/&gt;/g;
            print <<EOF;
            <row>
                <entry>Description:</entry>
                <entry>$Description</entry>
            </row>
            <row>
                <entry>Group:</entry>
                <entry>$Group</entry>
            </row>
EOF

            for my $Area (qw(SubGroup)) {
                for ( 1 .. 10 ) {
                    if ( $Item{$Area}->[$_] ) {
                        print <<EOF;
            <row>
                <entry>$Area:</entry>
                <entry>$Item{$Area}->[$_]->{Content}</entry>
            </row>
EOF
                    }
                }
            }
            my %ConfigItemDefault = $SysConfigObject->ConfigItemGet(
                Name    => $Name,
                Default => 1,
            );
            my $Valid    = defined $ConfigItemDefault{Valid}    ? $ConfigItemDefault{Valid}    : 1;
            my $Required = defined $ConfigItemDefault{Required} ? $ConfigItemDefault{Required} : 0;
            my $Key      = $Name;
            $Key =~ s/\\/\\\\/g;
            $Key =~ s/'/\'/g;
            $Key =~ s/###/'}->{'/g;
            my $Config = " \$Self->{'$Key'} = "
                . $SysConfigObject->_XML2Perl( Data => \%ConfigItemDefault );

            print <<EOF;
            <row>
                <entry>Valid:</entry>
                <entry>$Valid</entry>
            </row>
            <row>
                <entry>Required:</entry>
                <entry>$Required</entry>
            </row>
            <row>
                <entry>Config-Setting:</entry>
                <entry><programlisting><![CDATA[$Config]]></programlisting></entry>
            </row>
        </tbody>
    </tgroup>
</informaltable>
</section>
EOF
        }
        print "</section>\n";
    }
    print "</section>\n";
}
print "</appendix>\n";

exit;
