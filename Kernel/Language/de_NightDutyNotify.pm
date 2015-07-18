# --
# Kernel/Language/de.pm - provides German language translation
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# Copyright (C) 2010 Thomas Kaltenbrunner <tkaltenbrunner at opc.de>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_NightDutyNotify;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation} = {
        %{ $Self->{Translation} },
        'the ticket has these values' => 'das Ticket hat die folgenden Werte',
        'TicketLink' => 'Ticket Link',
        'New Ticket during DutyTime' => 'Neues Ticket während der Bereitschaft',
        'Hi' => 'Moin',
    };
    # $$STOP$$
    return;
}

1;
