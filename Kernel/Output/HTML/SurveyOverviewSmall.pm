# --
# Kernel/Output/HTML/SurveyOverviewSmall.pm.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::SurveyOverviewSmall;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject MainObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # need SurveyIDs
    if ( !$Param{SurveyIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the SurveyIDs!',
        );
        return;
    }

    # store the SurveyIDs locally
    my @IDs = @{ $Param{SurveyIDs} };

    # check ShowColumns parameter
    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
        @ShowColumns = @{ $Param{ShowColumns} };
    }

    my $Output = '';

    # show surveys if there are some
    if (@IDs) {

        # build column header blocks
        # currently sorting is not implemented on survey, leave the code for future implementation
        if (@ShowColumns) {
            for my $Column (@ShowColumns) {

                # create needed variables
                my $CSS = 'OverviewHeader';
                my $OrderBy;

                # set the correct Set CSS class and order by link
                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescendingLarge';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscendingLarge';
                    }
                }
                else {
                    $OrderBy = 'Up';
                }

                # output each header
                $Self->{LayoutObject}->Block(
                    Name => 'Record' . $Column . 'Header',
                    Data => {
                        %Param,
                        CSS     => $CSS,
                        OrderBy => $OrderBy,
                    },
                );
            }
        }

        my $Counter = 0;

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # get survey data
                my %Data = $Self->{SurveyObject}->SurveyGet(
                    UserID   => $Self->{UserID},
                    SurveyID => $ID,
                );

                next ID if !%Data;

                # build record block
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {
                        %Param,
                        %Data,
                    },
                );

                # build column record blocks
                if (@ShowColumns) {
                    COLUMN:
                    for my $Column (@ShowColumns) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %Data,
                            },
                        );

                        # show links if available
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkStart',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                    }
                }
            }
        }
    }

    # if there are no surveys to show, a no data found message is displayed in the table
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {
                TotalColumns => scalar @ShowColumns,
            },
        );
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
