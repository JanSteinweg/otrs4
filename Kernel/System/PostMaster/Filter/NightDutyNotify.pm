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
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{EmailObject}  = $Kernel::OM->Get('Kernel::System::Email');
    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');
    $Self->{LogOject}     = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{TimeObject}   = $Kernel::OM->Get('Kernel::System::Time');

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
#    if ( $Self->{Debug} > 0 ) {
        foreach ( keys %{$Param{GetParam}} ) {
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "$_: $Param{GetParam}->{$_}",
            );
        }
#    }
##-
    my $Calendar = $Self->{ConfigObject}->Get('Steinwegs::NightDutyCalendar') || '1';

    #+ NowTime
    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay, $YearDay, $IsDist) = localtime time;
    $Year  += 1900;
    $Month += 1;
    $Self->{LogOject}->Log(
        Priority => 'info',
        Message  => "S $Sec, M $Min, H $Hour, D $Day, M $Month, Y $Year, W $WeekDay, YD $YearDay, id $IsDist",
    );

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
            );
            if ( $hours{$Hour} )  {
                # jetzt Stunde?
                $IsDutyTime = 0; # heute+jetzt im aktiven kalender, d.h. keine Bereitschaft
                $Self->{LogOject}->Log(
                    Priority => 'info',
                    Message  => "No Hour $Hour",
                );
            } else {
                $Self->{LogOject}->Log(
                    Priority => 'info',
                    Message  => "Hour $Hour",
                );
            }
        }
    }
    
    #+ Ferien oder Bereitschaftszeit?
    if ( $Vacation || $IsDutyTime ) {
        my $DutyMail = $Self->{ConfigObject}->Get('Steinwegs::DutyEmail');
        return if !$DutyMail;
        #+ Send Mail to DutyMail
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "DoSend to $DutyMail",
        );
        #+ get Ticket
        my %SearchValues = ();
        if ( $Param{GetParam}->{'X-Priority'} ) {
            $SearchValues{PriorityIDs} = [ $Param{GetParam}->{'X-Priority'} ];
        }
        my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result      => 'ARRAY',
            Limit       => 1,
            UserID      => 1,
            TicketCreateTimeNewerMinutes => 1,
            StateType   => 'Open',
            Title       => $Param{GetParam}->{Subject},
            States      => [ 'new' ],
            From        => $Param{GetParam}->{From},
            Body        => $Param{GetParam}->{Body},
            %SearchValues,
        );
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "Tick_j ".join(',',@TicketIDs),
        );
        
        #+ Mail Values
        my $TicketID = 0;
        if ( @TicketIDs ) {
            $TicketID = $TicketIDs[0];
            $Self->{LogOject}->Log(
                Priority => 'info',
                Message  => "Tick $TicketID",
            );
        }
        my $Body = 'Hi,<br>folgende Werte betreffen das Ticket:<br>'.
            'From: '.$Param{GetParam}->{From}.'<br>'.
            'Subject: '.$Param{GetParam}->{Subject}.'<br>'.
            'Body: '.$Param{GetParam}->{Body}.'<br>'.
            'TicketID: '.$TicketID;
        my $From = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';
        
        #+ Senden
        my $Send = $Self->{EmailObject}->Send(
            From          => $From,
            To            => $DutyMail,
            Subject       => 'There is a new Ticket in the System',
            Charset       => $Param{GetParam}->{'Charset'} || 'utf-8',
            MimeType      => 'text/html',
            Body          => $Body,
            InReplyTo     => $Param{GetParam}->{'Message-ID'},
        );
        $Self->{LogOject}->Log(
            Priority => 'info',
            Message  => "Status $Send",
        );
        
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
