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
    my $SendRequest = $Self->{SurveyObject}->RequestCount(
        SurveyID => $SurveyID,
        ValidID  => 'all',
    );
    my $RequestComplete = $Self->{SurveyObject}->RequestCount(
        SurveyID => $SurveyID,
        ValidID  => 0,
    );
    $Survey{SendRequest}     = $SendRequest;
    $Survey{RequestComplete} = $RequestComplete;

    # get selected queues
    my %Queues = $Self->{QueueObject}->GetAllQueues();
    my @QueueList = map { $Queues{$_} } @{ $Survey{Queues} };
    @QueueList = sort { lc $a cmp lc $b } @QueueList;
    my $QueueListString = join q{, }, @QueueList;

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
                    my $VoteCount = $Self->{SurveyObject}->VoteCount(
                        QuestionID => $Question->{QuestionID},
                        VoteValue  => $Row->{AnswerID},
                    );
                    my $Percent = 0;

                    # calculate the percents
                    if ($RequestComplete) {
                        $Percent = 100 / $RequestComplete * $VoteCount;
                        $Percent = sprintf( "%.0f", $Percent );
                    }
                    my %Data;
                    $Data{Answer}        = $Row->{Answer};
                    $Data{AnswerPercent} = $Percent;
                    push( @Answers, \%Data );
                }
            }
            elsif ( $Question->{Type} eq 'Textarea' ) {
                my $AnswerNo = $Self->{SurveyObject}->VoteCount(
                    QuestionID => $Question->{QuestionID},
                    VoteValue  => '',
                );
                my $Percent = 0;

                # calculate the percents
                if ($RequestComplete) {
                    $Percent = 100 / $RequestComplete * $AnswerNo;
                    $Percent = sprintf( "%.0f", $Percent );
                }
                my %Data;
                $Data{Answer} = "answered";
                if ( !$RequestComplete ) {
                    $Data{AnswerPercent} = 0;
                }
                else {
                    $Data{AnswerPercent} = 100 - $Percent;
                }
                push( @Answers, \%Data );
                my %Data2;
                $Data2{Answer}        = "not answered";
                $Data2{AnswerPercent} = $Percent;
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
