# --
# Kernel/Modules/AgentSurveyZoom.pm - a survey module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyZoom;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Type;
use Kernel::System::Service;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{SurveyObject}    = Kernel::System::Survey->new( %{$Self} );
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{TypeObject}      = Kernel::System::Type->new( %{$Self} );
    $Self->{ServiceObject}   = Kernel::System::Service->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # view attachment for HTML email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # get params
        my $SurveyID    = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $SurveyField = $Self->{ParamObject}->GetParam( Param => "SurveyField" );

        # needed params
        for my $Needed (qw( SurveyID SurveyField )) {
            if ( !$Needed ) {
                $Self->{LogObject}->Log(
                    Message  => "Needed Param: $Needed!",
                    Priority => 'error',
                );

                return;
            }
        }

        if ( $SurveyField ne 'Introduction' && $SurveyField ne 'Description' ) {
            $Self->{LogObject}->Log(
                Message  => "Invalid SurveyField Param: $SurveyField!",
                Priority => 'error',
            );

            return;
        }

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            )
        {
            $Self->{LogObject}->Log(
                Message  => "Invalid SurveyID: $SurveyID!",
                Priority => 'error',
            );

            return;
        }

        # get all attributes of the survey
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        if ( $Survey{$SurveyField} ) {

            # clean HTML and convert the Field in HTML (\n --><br>)
            $Survey{$SurveyField} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
            $Survey{$SurveyField} = $Self->{LayoutObject}->Ascii2Html(
                Text           => $Survey{$SurveyField},
                HTMLResultMode => 1,
            );
        }
        else {

            return;
        }

        # convert text area fields to ASCII
        $Survey{$SurveyField} = $Self->{HTMLUtilsObject}->ToAscii( String => $Survey{$SurveyField} );

        $Survey{$SurveyField} = $Self->{HTMLUtilsObject}->DocumentComplete(
            String  => $Survey{$SurveyField},
            Charset => 'utf-8',
        );

        return $Self->{LayoutObject}->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Survey{$SurveyField},
        );
    }

    # ------------------------------------------------------------ #
    # survey status
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyStatus' ) {
        my $SurveyID  = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $NewStatus = $Self->{ParamObject}->GetParam( Param => "NewStatus" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists(
                ElementID => $SurveyID,
                Element   => 'Survey'
            ) ne
            'Yes'
            )
        {

            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey!',
                WithHeader => 'yes',
            );
        }

        # set a new status
        my $StatusSet = $Self->{SurveyObject}->SurveyStatusSet(
            SurveyID  => $SurveyID,
            NewStatus => $NewStatus,
        );
        my $Message = '';
        if ( defined($StatusSet) && $StatusSet eq 'NoQuestion' ) {
            $Message = ';Message=NoQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'IncompleteQuestion' ) {
            $Message = ';Message=IncompleteQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'StatusSet' ) {
            $Message = ';Message=StatusSet';
        }

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentSurveyZoom;SurveyID=$SurveyID$Message",
        );
    }

    # ------------------------------------------------------------ #
    # survey zoom
    # ------------------------------------------------------------ #

    # get params
    my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
    my $Message  = $Self->{ParamObject}->GetParam( Param => "Message" );

##+ voteyears
    my $VoteYear  = $Self->{ParamObject}->GetParam( Param => "VoteYear" ) || 0;
    my $VoteMonth = $Self->{ParamObject}->GetParam( Param => "VoteMonth" ) || 0;
    if ( $VoteMonth > 0 && $VoteMonth < 10 ){
        $VoteMonth = '0'.$VoteMonth;
    }
##-

    # check if survey exists
    if (
        !$SurveyID ||
        $Self->{SurveyObject}->ElementExists(
            ElementID => $SurveyID,
            Element   => 'Survey'
        ) ne
        'Yes'
        )
    {
        $Message = ';Message=NoSurveyID';

        return $Self->{LayoutObject}->Redirect( OP => "Action=AgentSurveyOverview$Message" );
    }

    # output header
    $Output = $Self->{LayoutObject}->Header( Title => 'Survey' );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # output messages if status was changed
    if ( defined($Message) && $Message eq 'NoQuestion' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => 'Can\'t set new status! No questions defined.',
        );
    }
    elsif ( defined($Message) && $Message eq 'IncompleteQuestion' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => 'Can\'t set new status! Questions incomplete.',
        );
    }
    elsif ( defined($Message) && $Message eq 'StatusSet' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Info     => 'Status changed.',
        );
    }

    # get all attributes of the survey
    my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );
    my %HTML;

    # clean HTML and convert the textareas in HTML (\n --><br>)
    FIELD:
    for my $SurveyField (qw( Introduction Description )) {
        next FIELD if !$Survey{$SurveyField};

        $Survey{$SurveyField} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;

        if ($1) {
            $HTML{$SurveyField} = 1;
        }

        $Survey{$SurveyField} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Survey{$SurveyField},
            HTMLResultMode => 1,
        );
    }

    # get numbers of requests and votes
##+ voteyear
#    my $SendRequest = $Self->{SurveyObject}->RequestCount(
#        SurveyID => $SurveyID,
#        ValidID  => 'all',
#    );
#    my $RequestComplete = $Self->{SurveyObject}->RequestCount(
#        SurveyID => $SurveyID,
#        ValidID  => 0,
#    );
    my $SendRequest = 0;
    my $RequestComplete = 0;
    if ( $VoteYear == 0 ) {
#+ org
        $SendRequest = $Self->{SurveyObject}->RequestCount(
            SurveyID => $SurveyID,
            ValidID  => 'all',
        );
        $RequestComplete = $Self->{SurveyObject}->RequestCount(
            SurveyID => $SurveyID,
            ValidID  => 0,
        );
#-
    } else {
        if ( $VoteMonth == 0 ) {
            $SendRequest = $Self->{SurveyObject}->RequestCount(
                SurveyID => $SurveyID,
                ValidID  => 'all',
                VoteYear => $VoteYear,
            );
            $RequestComplete = $Self->{SurveyObject}->RequestCount(
                SurveyID => $SurveyID,
                ValidID  => 0,
                VoteYear => $VoteYear,
            );
        } else {
            $SendRequest = $Self->{SurveyObject}->RequestCount(
                SurveyID  => $SurveyID,
                ValidID   => 'all',
                VoteYear  => $VoteYear,
                VoteMonth => $VoteMonth,
            );
            $RequestComplete = $Self->{SurveyObject}->RequestCount(
                SurveyID  => $SurveyID,
                ValidID   => 0,
                VoteYear  => $VoteYear,
                VoteMonth => $VoteMonth,
            );
        }
    }
##-
    $Survey{SendRequest}     = $SendRequest;
    $Survey{RequestComplete} = $RequestComplete;

    # get selected queues
    my %Queues = $Self->{QueueObject}->GetAllQueues();
    my @QueueList = map { $Queues{$_} } @{ $Survey{Queues} };
##+ sort warning
#    @QueueList = sort { lc $a cmp lc $b } @QueueList;
    @QueueList = sort { lc $a cmp lc $b } @QueueList if ( $a && $b);
#    my $QueueListString = join q{, }, @QueueList;
    my $QueueListString = '';
    for my $q (@QueueList) {
        if ( $q && length($q) > 0 ) {
            $QueueListString .= $q.", ";
        } else {
            $QueueListString .= ", ";
        }
    }
    if ( length($QueueListString) > 3 ) {
        $QueueListString = substr($QueueListString,0,-2);
    }
##-

    my $NoQueueMessage = '';
    if ( !$QueueListString ) {
        $QueueListString = $Self->{LayoutObject}->{LanguageObject}->Translate('- No queue selected -');
    }

    # print the main table.
    $Self->{LayoutObject}->Block(
        Name => 'SurveyZoom',
        Data => {
            %Survey,
            NoQueueMessage  => $NoQueueMessage,
            QueueListString => $QueueListString,
            HTMLRichTextHeightDefault =>
                $Self->{ConfigObject}->Get('Survey::Frontend::HTMLRichTextHeightDefault') || 80,
            HTMLRichTextHeightMax =>
                $Self->{ConfigObject}->Get('Survey::Frontend::HTMLRichTextHeightMax') || 2500,
        },
    );

    # check if the send condition ticket type check is enabled
    if ( $Self->{ConfigObject}->Get('Survey::CheckSendConditionTicketType') ) {

        # get selected ticket types
        my %TicketTypes = $Self->{TypeObject}->TypeList();
        my @TicketTypeList = map { $TicketTypes{$_} ? $TicketTypes{$_} : () } @{ $Survey{TicketTypeIDs} };
        @TicketTypeList = sort { lc $a cmp lc $b } @TicketTypeList;
        my $TicketTypeListString = join q{, }, @TicketTypeList;

        if ( !$TicketTypeListString ) {
            $TicketTypeListString = '- No ticket type selected -';
        }

        $Self->{LayoutObject}->Block(
            Name => 'TicketTypes',
            Data => {
                TicketTypeListString => $TicketTypeListString,
            },
        );
    }

    # check if the send condition service check is enabled
    if ( $Self->{ConfigObject}->Get('Survey::CheckSendConditionService') ) {

        # get selected ticket types
        my %Services = $Self->{ServiceObject}->ServiceList(
            UserID => $Self->{UserID},
        );
        my @ServiceList = map { $Services{$_} ? $Services{$_} : () } @{ $Survey{ServiceIDs} };
        @ServiceList = sort { lc $a cmp lc $b } @ServiceList;
        my $ServiceListString = join q{, }, @ServiceList;

        if ( !$ServiceListString ) {
            $ServiceListString = '- No ticket service selected -';
        }

        $Self->{LayoutObject}->Block(
            Name => 'TicketServices',
            Data => {
                ServiceListString => $ServiceListString,
            },
        );
    }

    # run survey menu modules
    my $MenuModuleConfig = $Self->{ConfigObject}->Get('Survey::Frontend::MenuModule');
    if ( IsHashRefWithData($MenuModuleConfig) ) {
        my %Menus   = %{$MenuModuleConfig};
        my $Counter = 0;
        MENU:
        for my $Menu ( sort keys %Menus ) {

            # menu SatsDetails needs to have a complete request
            if (
                defined $Menus{$Menu}->{Action}
                && $Menus{$Menu}->{Action} eq 'AgentSurveyStats'
                && !$RequestComplete
                )
            {
                next MENU;
            }

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    SurveyID => $Survey{SurveyID},
                );

                # set classes
                if ( $Menus{$Menu}->{Target} ) {

                    if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                        $Menus{$Menu}->{Class} = 'AsPopup';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                        $Menus{$Menu}->{Class} = 'HistoryBack';
                    }
                }

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Survey  => {%Survey},
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                    MenuID  => 'Menu' . $Menu,
                );
            }
            else {

                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # output the possible status menu
    my %NewStatus = (
        ChangeStatus => '- Change Status -',
        Master       => 'Master',
        Valid        => 'Valid',
        Invalid      => 'Invalid',

    );

    if ( $Survey{Status} eq 'New' ) {
        delete $NewStatus{Invalid};
    }
    else {
        delete $NewStatus{ $Survey{Status} };
    }

    my $NewStatusStr = $Self->{LayoutObject}->BuildSelection(
        Name       => 'NewStatus',
        ID         => 'NewStatus',
        Data       => \%NewStatus,
        SelectedID => 'ChangeStatus',
        Title      => $Self->{LayoutObject}->{LanguageObject}->Translate('New Status'),
    );

    $Self->{LayoutObject}->Block(
        Name => 'SurveyStatus',
        Data => {
            NewStatusStr => $NewStatusStr,
            SurveyID     => $SurveyID,
        },
    );

    # output the survey common blocks
    for my $Field (qw( Introduction Description)) {
        $Self->{LayoutObject}->Block(
            Name => 'SurveyBlock',
            Data => {
                Title       => "Survey $Field",
                SurveyField => $Field,
            },
        );
        if ( $HTML{$Field} ) {
            $Self->{LayoutObject}->Block(
                Name => 'BodyHTML',
                Data => {
                    SurveyField => $Field,
                    SurveyID    => $SurveyID,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'BodyPlain',
                Data => {
                    Label   => $Field,
                    Content => $Survey{$Field},
                },
            );
        }
    }
    
##+ VoteYears
    my $CreateYear   = substr($Survey{CreateTime},0,4); # 2009-04-20 09:28:43
    my $CreateMonth  = substr($Survey{CreateTime},5,2); # 2009-04-20 09:28:43
    my $NowYear      = substr(gmtime(),-4,4);           # Mon Nov 18 14:12:48 2002
    my $Years        = $NowYear - $CreateYear;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $NowMonth     = $mon+1; 

    if ($Years > 0 ) {
        my $Year = 0;
        $Self->{LayoutObject}->Block(
            Name => 'VoteYears',
            Data => { %Survey, },
        );
        for my $y (0..$Years){
            $Year = $CreateYear + $y;
            my $current = '';
            if ( $VoteYear == $Year ) {
                $current = 'style="text-decoration: underline"';
            }
            $Self->{LayoutObject}->Block(
                Name => 'VoteYear',
                Data => {
                    %Survey,
                    VoteYear => $Year,
                    Current  => $current,
                },
            );
        }
    }
    if ( $CreateYear == $NowYear ) {
        $VoteYear = $NowYear
    }
    if ( $VoteYear ) {
        my $start = 1;
        my $end = 12;
        $Self->{LayoutObject}->Block(
            Name => 'VoteMonths',
            Data => {
                %Survey, 
                VoteYear => $VoteYear,
            },
        );
        if ( $VoteYear == $CreateYear ) {
            $start = $CreateMonth;
        }
        if ( $VoteYear == $NowYear ) {
            $end = $NowMonth;
        }
        for my $m ($start..$end){
            my $current = '';
            if ( $VoteMonth == $m ) {
                $current = 'class="current"';
            }
            $Self->{LayoutObject}->Block(
                Name => 'VoteMonth',
                Data => {
                    %Survey,
                    VoteMonth => $m,
                    VoteYear  => $VoteYear,
                    Current => $current,
                },
            );
        }
    }
##-

    # display stats if status Master, Valid or Invalid
    if ( $Survey{Status} eq 'New' ) {
        $Self->{LayoutObject}->Block( Name => 'NoStatResults' );
    }
    elsif (
        $Survey{Status} eq 'Master'
        || $Survey{Status} eq 'Valid'
        || $Survey{Status} eq 'Invalid'
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'SurveyEditStats',
            Data => {
                SurveyID => $SurveyID,
            },
        );

        # get all questions of the survey
        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        for my $Question (@QuestionList) {
            $Self->{LayoutObject}->Block(
                Name => 'SurveyEditStatsQuestion',
                Data => $Question,
            );
            my @Answers;

            # generate the answers of the question
            if (
                $Question->{Type} eq 'YesNo'
                || $Question->{Type} eq 'Radio'
                || $Question->{Type} eq 'Checkbox'
                )
            {
                my @AnswerList;

                # set answers to Yes and No if type was YesNo
                if ( $Question->{Type} eq 'YesNo' ) {
                    my %Data;
                    $Data{Answer}   = "Yes";
                    $Data{AnswerID} = "Yes";
                    push( @AnswerList, \%Data );
                    my %Data2;
                    $Data2{Answer}   = "No";
                    $Data2{AnswerID} = "No";
                    push( @AnswerList, \%Data2 );
                }
                else {

                    # get all answers of a question
                    @AnswerList = $Self->{SurveyObject}->AnswerList(
                        QuestionID => $Question->{QuestionID},
                    );
                }
                for my $Row (@AnswerList) {
##+ VoteYear
                    my $VoteCount = 0;
#+ org
#                    my $VoteCount = $Self->{SurveyObject}->VoteCount(
#                        QuestionID => $Question->{QuestionID},
#                        VoteValue  => $Row->{AnswerID},
#                    );
#-
                    if ( $VoteYear == 0 ) {
                        $VoteCount = $Self->{SurveyObject}->VoteCount(
                            QuestionID => $Question->{QuestionID},
                            VoteValue  => $Row->{AnswerID},
                        );
                    } else {
                        if ( $VoteMonth == 0 ) {
                            $VoteCount = $Self->{SurveyObject}->VoteCount(
                                QuestionID => $Question->{QuestionID},
                                VoteValue  => $Row->{AnswerID},
                                VoteYear   => $VoteYear,
                            );
                        } else {
                            $VoteCount = $Self->{SurveyObject}->VoteCount(
                                QuestionID => $Question->{QuestionID},
                                VoteValue  => $Row->{AnswerID},
                                VoteYear   => $VoteYear,
                                VoteMonth  => $VoteMonth,
                            );
                        }
                    }
##-
                    my $Percent = 0;
                    my $PercentShow = 0;

                    # calculate the percents
                    if ($RequestComplete) {
                        $Percent = 100 / $RequestComplete * $VoteCount;
                        $Percent = sprintf( "%.0f", $Percent );
                        $PercentShow = sprintf( "%.1f", $Percent ); ##+ more %
                    }
                    my %Data;
                    $Data{Answer}            = $Row->{Answer};
                    $Data{AnswerPercent}     = $Percent;
                    $Data{AnswerPercentShow} = $PercentShow;
                    $Data{AnswerVotes}       = $VoteCount;
                    push( @Answers, \%Data );
                }
            }
            elsif ( $Question->{Type} eq 'Textarea' ) {
##+ VoteYear
                my $AnswerNo = 0;
                if ( $VoteYear == 0 ) {
#+ org
#                    my $AnswerNo = $Self->{SurveyObject}->VoteCount(
                    $AnswerNo = $Self->{SurveyObject}->VoteCount(
                        QuestionID => $Question->{QuestionID},
                        VoteValue  => '',
                    );
#-
                } else {
                    if ( $VoteMonth == 0 ) {
                        $AnswerNo = $Self->{SurveyObject}->VoteCount(
                            QuestionID => $Question->{QuestionID},
                            VoteValue  => '',
                            VoteYear   => $VoteYear,
                        );
                    } else {
                        $AnswerNo = $Self->{SurveyObject}->VoteCount(
                            QuestionID => $Question->{QuestionID},
                            VoteValue  => '',
                            VoteYear   => $VoteYear,
                            VoteMonth  => $VoteMonth,
                        );
                    }
                }
##-
                my $Percent = 0;
                my $PercentShow = 0;

                # calculate the percents
                if ($RequestComplete) {
                    $Percent     = 100 / $RequestComplete * $AnswerNo;
                    $Percent     = sprintf( "%.0f", $Percent );
                    $PercentShow = sprintf( "%.1f", $Percent );
                }
                my %Data;
                $Data{Answer} = "answered";
                if ( !$RequestComplete ) {
                    $Data{AnswerPercent} = 0;
                    $Data{AnswerPercentShow} = 0;
                    $Data{AnswerVotes} = 0;
                }
                else {
                    
                    #$Data{AnswerPercent} = 100 - $Percent;
                    $Data{AnswerPercent} = 100 - $PercentShow;
                    $Data{AnswerPercentShow} = 100 - $PercentShow;
                    $Data{AnswerVotes} = $RequestComplete - $AnswerNo;
                }
                push( @Answers, \%Data );
                my %Data2;
                $Data2{Answer}            = "not answered";
                $Data2{AnswerPercent}     = $Percent;
                $Data2{AnswerPercentShow} = $PercentShow;
                $Data2{AnswerVotes}       = $AnswerNo;
                push( @Answers, \%Data2 );
            }

            # output all answers of the survey
            for my $Row (@Answers) {
                $Row->{AnswerPercentTable} = $Row->{AnswerPercent};
                if ( !$Row->{AnswerPercent} ) {
                    $Row->{AnswerPercentTable} = 1;
                }
                $Self->{LayoutObject}->Block(
                    Name => 'SurveyEditStatsAnswer',
                    Data => $Row,
                );
            }
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyZoom',
        Data         => {%Param},
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
