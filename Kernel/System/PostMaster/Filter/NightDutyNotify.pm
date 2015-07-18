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
    my $Calendar = $Self->{ConfigObject}->Get('Steinwegs::NightDutyCalendar') || '1';

    #+ NowTime
    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay, $YearDay, $IsDist) = localtime time;
    $Year  += 1900;
    $Month += 1;
    $Self->{LogOject}->Log(
        Priority => 'info',
        Message  => "S $Sec, M $Min, H $Hour, D $Day, M $Month, Y $Year, W $WeekDay, YD $YearDay, id $IsDist",
    ) if ( $Self->{Debug} > 0 );

    #+ Ferien?
    my $Vacation = 0;
    $Vacation = $Self->{TimeObject}->VacationCheck(
        Year     => $Year,
        Month    => $Month,
        Day      => $Day,
        Calendar => $Calendar,
    );
    
    my $IsDutyTime = 1;
    if ( !$Vacation ) {
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
                $IsDutyTime = 0; # heute+jetzt im aktiven kalender, d.h. keine Bereitschaft
                $Self->{LogOject}->Log(
                    Priority => 'info',
                    Message  => "No Hour $Hour",
                ) if ( $Self->{Debug} > 0 );
            } else {
                $Self->{LogOject}->Log(
                    Priority => 'info',
                    Message  => "Hour $Hour",
                ) if ( $Self->{Debug} > 0 );
            }
        }
    }
    
    #+ Ferien oder Bereitschaftszeit?
    if ( $Vacation || $IsDutyTime ) {
        my $DutyMail = $Self->{ConfigObject}->Get('Steinwegs::DutyEmail');
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
        my %SearchValues = ();
        if ( $Param{GetParam}->{'X-Priority'} || $Param{GetParam}->{'X-OTRS-FollowUp-Priority'} ) {
            my $prio = $Param{GetParam}->{'X-Priority'} || $Param{GetParam}->{'X-OTRS-FollowUp-Priority'};
            $SearchValues{PriorityIDs} = [ $prio ];
        } else {
            $SearchValues{Priorities} = [ $Self->{ConfigObject}->Get('PostmasterDefaultPriority') ];
        }

        my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result        => 'ARRAY',
            Limit         => 1,
            UserID        => 1,
            TicketCreateTimeNewerMinutes => 1,
            States        => [ $Self->{ConfigObject}->Get('PostmasterDefaultState') || 'new' ],
            StateType     => 'Open',
            Title         => $Param{GetParam}->{Subject},
            From          => $Param{GetParam}->{From},
            %SearchValues,
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
        my $MailBody = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Param{GetParam}->{Body},
        );
        my $Lines = $Self->{ConfigObject}->Get('Steinwegs::DutyBodyLines') || '';
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
                $Lines = '['.$Lines.']';
            } else{
                $Lines = '';
            }
        }

         #+ MailSubject
        # TODO - length nur, wenn länger als length
        my $Length = $Self->{ConfigObject}->Get('Steinwegs::DutySubjectLength') || '';
        my $MailSubject = $Param{GetParam}->{Subject};
        if ( $Length  && $Length > 0 ) {
            $MailSubject = substr($Param{GetParam}->{Subject},0,$Length);
            if ( length ( $Param{GetParam}->{Subject} ) > $Length ) {
                $MailSubject .= '...';
            }
            $Length = '['.$Length.']';
        }

         #+ Duty Mail Body
        my $DutyBody =
            $Self-> {LayoutObject}->{LanguageObject}->Translate('Hi').',<br />'.
            $Self-> {LayoutObject}->{LanguageObject}->Translate('the ticket has these values').'<br />'.
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('From').'</b>: $Param{GetParam}->{From} <br>'.
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('Subject')." $Length</b> : $MailSubject<br>".
            '<b>'.$Self-> {LayoutObject}->{LanguageObject}->Translate('Body')." $Lines</b> : $MailBody<br>".
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
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "DutySend OK $TicketID",
        ) if $Send;
    }
    return 1;
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
