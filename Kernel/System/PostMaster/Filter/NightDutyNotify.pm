# --
# Kernel/System/PostMaster/Filter/NightDutyNotify.pm - Night Duty Notification Filter
# Copyright (C) 2015 Jan Steinweg
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::NightDutyNotify;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Time',
    'Kernel::System::Email',
    'Kernel::System::Ticket',
    'Kernel::System::HTMLUtils',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Notification',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{EmailObject}     = $Kernel::OM->Get('Kernel::System::Email');
    $Self->{ConfigObject}    = $Kernel::OM->Get('Kernel::Config');
    $Self->{LogOject}        = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{TimeObject}      = $Kernel::OM->Get('Kernel::System::Time');
    $Self->{HTMLUtilsObject} = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    $Self->{LayoutObject}    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $Self->{NotifyObject}    = $Kernel::OM->Get('Kernel::System::Notification');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config options, use defaults unless value specified
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        KEY:
        for my $Key ( keys( %{ $Param{JobConfig} } ) ) {
            next KEY if !$Self->{Config}->{$Key};
            $Self->{Config}->{$Key} = $Param{JobConfig}->{$Key};
        }
    }

##+ MailLog
    if ( $Self->{Debug} > 1 ) {
        foreach ( keys %{$Param{GetParam}} ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "$_: $Param{GetParam}->{$_}",
            );
        }
    }
##-
    my $Calendar = $Self->{ConfigObject}->Get('NightDutyNotify::NightDutyCalendar') || '1';

    #+ NowTime
    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay, $YearDay, $IsDist) = localtime time;
    $Year  += 1900;
    $Month += 1;
    $Self->{LogOject}->Log(
        Priority => 'info',
        Message  => "S $Sec, M $Min, H $Hour, D $Day, M $Month, Y $Year, W $WeekDay, YD $YearDay, id $IsDist",
    ) if ( $Self->{Debug} > 0 );

    #+ Ferien?
    my $Vacation = $Self->{TimeObject}->VacationCheck(
        Year     => $Year,
        Month    => $Month,
        Day      => $Day,
        Calendar => $Calendar,
    );

    # DutyTime ?
    my $IsDutyTime = 1;
    if ( !$Vacation ) {
        $IsDutyTime = $Self->_IsDutyTimeCheck(
            Calendar => $Calendar,
            Weekday  => $WeekDay,
            Hour     => $Hour,
        );
    }
    
    #+ Ferien oder Bereitschaftszeit?
    if ( $Vacation || $IsDutyTime ) {
        my $DutyMail = $Self->{ConfigObject}->Get('NightDutyNotify::DutyEmail');
        #+ ERROR no DutyEmail
        if ( !$DutyMail ) {
            $Self->{LogOject}->Log(
                Priority => 'error',
                Message  => "No DutyEmail defined",
            );
            return;
        }
        #+ Send Mail to DutyMail
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "DoSend to $DutyMail",
        );

        #+ get Ticket

        my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result        => 'ARRAY',
            Limit         => 1,
            UserID        => 1,
            TicketCreateTimeNewerMinutes => 1,
            States        => [ $Self->{ConfigObject}->Get('PostmasterDefaultState') || 'new' ],
            StateType     => 'Open',
            Title         => $Param{GetParam}->{Subject},
            From          => $Param{GetParam}->{From},
        );
        my $TicketID = 0;
        my %Ticket;
        if ( @TicketIDs ) {
            $TicketID = $TicketIDs[0];
            %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
                TicketID      => $TicketID,
                UserID        => 1,
            );
##+ TicketLog
    if ( $Self->{Debug} > 1 ) {
        foreach ( keys %Ticket ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "$_: $Ticket{$_}",
            );
        }
    }
##-
        }

        #+ Duty Mail Values
         #+ TicketLink
        my $Link =
            $Self->{ConfigObject}->Get('HttpType').'://'.
            $Self->{ConfigObject}->Get('FQDN').'/'.
            $Self->{ConfigObject}->Get('ScriptAlias').
            'index.pl?Action=AgentTicketZoom;TicketID='.$TicketID;

         #+ MailBody
        my ( $MailBody, $Lines ) = $Self->_ShortenBody(
            Body => $Param{GetParam}->{Body},
        );

         #+ MailSubject
        my ( $MailSubject, $Length ) = $Self->_ShortenSubject(
            Subject => $Param{GetParam}->{Subject},
        );

         #+ Duty Mail Body
        my $DutyBody =
            $Self-> {LayoutObject}->{LanguageObject}->Translate('Hi').',<br />'.
            $Self-> {LayoutObject}->{LanguageObject}->Translate('the ticket has these values').'<br />'.
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('From')."</b>: $Param{GetParam}->{From} <br>".
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('Subject')."$Length</b>: $MailSubject<br>".
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('Body')."$Lines</b>: $MailBody<br>".
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('TicketNumber')."</b>: $Ticket{TicketNumber}<br>".
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('TicketLink')."</b>: $Link";
        $DutyBody = $Self->{HTMLUtilsObject}->LinkQuote(
            String    => $DutyBody,
        );
        my $From = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';

        #+ Senden
        my $Send = $Self->{EmailObject}->Send(
            From          => $From,
            To            => $DutyMail,
            Subject       => $Self-> {LayoutObject}->{LanguageObject}->Translate('New Ticket during DutyTime').": $Ticket{TicketNumber}",
            Charset       => $Param{GetParam}->{'Charset'} || 'utf-8',
            MimeType      => 'text/html',
            Body          => $DutyBody,
            InReplyTo     => $Param{GetParam}->{'Message-ID'},
        );
        if ( $Send ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "DutySend OK: $TicketID",
            );
            if ( $Self->{ConfigObject}->Get('NightDutyNotify::CreateHistory') ) {
                # Ticket History
                $Kernel::OM->Get('Kernel::System::Ticket')->HistoryAdd(
                    Name         => 'Duty Notification to '.$DutyMail,
                    HistoryType  => 'SendAgentNotification',
                    TicketID     => $TicketID,
                    CreateUserID => 1,
                );
            }
        }
    }
    return 1;
}

sub _IsDutyTimeCheck{
    my ( $Self, %Param ) = @_;

    for ( qw (Weekday Hour) ) {
        if ( !$Param{$_} ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "No $_ but required",
            );
            return;
        }
    }

    my $Calendar = $Param{Calendar} || 1;
    my $WeekDay  = $Param{WeekDay};
    my $Hour     = $Param{Hour};
    
    my @WeekDays = qw(Sun Mon Tue Wed Thu Fri Sat);
    my $DayName = $WeekDays[$WeekDay];
    #+ TimeWorkingHours?
    my $TimeWorkingHours = $Self->{ConfigObject}->Get('TimeWorkingHours::Calendar'.$Calendar);
    if ( $TimeWorkingHours->{ $WeekDays[$WeekDay] } ) {
        # heute?
        my %hours;
        $hours{$_} = 1 for @{$TimeWorkingHours->{ $WeekDays[$WeekDay] }};
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "W $WeekDay $DayName, H $Hour -".$hours{$Hour},
        ) if ( $Self->{Debug} > 0 );
        if ( $hours{$Hour} )  {
            # jetzt Stunde?
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "No Hour $Hour",
            ) if ( $Self->{Debug} > 0 );
            return 0;  # heute+jetzt im aktiven kalender, d.h. keine Bereitschaft
        } else {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "Hour $Hour",
            ) if ( $Self->{Debug} > 0 );
            return 1; # heute+jetzt nicht in kalender, d.h. Bereitschaft
        }
    }
    # nicht Heute, bzw Hour = Arbeitszeit
    return 0;
}

sub _ShortenBody{
    my ( $Self, %Param ) = @_;
    
    for ( qw (Body) ) {
        if ( !$Param{$_} ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "No $_ but required",
            );
            return;
        }
    }
    
    my $MailBody = $Self->{HTMLUtilsObject}->ToHTML(
        String => $Param{Body},
    );
    my $Lines = $Self->{ConfigObject}->Get('NightDutyNotify::DutyBodyLines') || '';
    if ( $Lines && $Lines > 0 ) {
        my @Body = split( /\n/, $MailBody );
        my $NewBody = '';
        # wenn body nicht kleiner||gleich DutyBodyLines, dann verkürzen 
        if ( !($#Body <= $Lines) ) {
            for ( my $i = 0; $i < $Lines; $i++ ) {
                $NewBody .= "> $Body[$i]";
               # add new line
                if ( $i < ( $Lines - 1 ) ) {
                    $NewBody .= "\n";
                }
            }
            $MailBody = $NewBody;
            if ( $#Body > $Lines ) {
                $MailBody .= '...';
            }
            $Lines = ' ['.$Lines.'] ';
        } else{
            $Lines = '';
        }
    }
    return ( $MailBody, $Lines );
}

sub _ShortenSubject {
    my ( $Self, %Param ) = @_;
    
    for ( qw (Subject) ) {
        if ( !$Param{$_} ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "No $_ but required",
            );
            return;
        }
    }

    my $MailSubject = $Param{Subject};
    my $Length = $Self->{ConfigObject}->Get('NightDutyNotify::DutySubjectLength');
    if ( $Length  && $Length > 0 && length($MailSubject) > $Length) {
        $MailSubject = substr($Param{Subject},0,$Length);
        if ( length ( $Param{Subject} ) > $Length ) {
            $MailSubject .= '...';
        }
        $Length = ' ['.$Length.'] ';
    } else {
        $Length = '';
    }
    return ( $MailSubject, $Length );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
