# --
# Kernel/Language/nb_NO_Survey.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '';
    $Self->{Translation}->{'Add New Survey'} = '';
    $Self->{Translation}->{'Survey Edit'} = 'Rediger spørreundersøkelse';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Rediger spørsmål til spørreundersøkelsen';
    $Self->{Translation}->{'Question Edit'} = '';
    $Self->{Translation}->{'Answer Edit'} = '';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = '';
    $Self->{Translation}->{'Status changed.'} = '';
    $Self->{Translation}->{'Thank you for your feedback.'} = '';
    $Self->{Translation}->{'The survey is finished.'} = '';
    $Self->{Translation}->{'Complete'} = '';
    $Self->{Translation}->{'Incomplete'} = '';
    $Self->{Translation}->{'Checkbox (List)'} = '';
    $Self->{Translation}->{'Radio'} = '';
    $Self->{Translation}->{'Radio (List)'} = '';
    $Self->{Translation}->{'Stats Overview'} = 'Statistikkoversikt';
    $Self->{Translation}->{'Survey Description'} = '';
    $Self->{Translation}->{'Survey Introduction'} = '';
    $Self->{Translation}->{'Yes/No'} = '';
    $Self->{Translation}->{'YesNo'} = '';
    $Self->{Translation}->{'answered'} = '';
    $Self->{Translation}->{'not answered'} = '';
    $Self->{Translation}->{'Stats Detail'} = '';
    $Self->{Translation}->{'Stats Details'} = '';
    $Self->{Translation}->{'You have already answered the survey.'} = '';
    $Self->{Translation}->{'Survey#'} = '';
    $Self->{Translation}->{'- No queue selected -'} = '';
    $Self->{Translation}->{'Master'} = '';
    $Self->{Translation}->{'New Status'} = '';
    $Self->{Translation}->{'Question Type'} = '';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Lag ny spørreundersøkelse';
    $Self->{Translation}->{'Introduction'} = 'Introduksjon';
    $Self->{Translation}->{'Internal Description'} = 'Intern beskrivelse';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Rediger generell informasjon';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Rediger spørsmål';
    $Self->{Translation}->{'Add Question'} = 'Legg til spørsmål';
    $Self->{Translation}->{'Type the question'} = 'Skriv inn spørsmålet';
    $Self->{Translation}->{'Answer required'} = '';
    $Self->{Translation}->{'Survey Questions'} = 'Spørsmål til spørreundersøkelsen';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Ingen spørsmål lagret for denne spørreundersøkelsen.';
    $Self->{Translation}->{'Question'} = 'Spørsmål';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        '';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        '';
    $Self->{Translation}->{'Edit Question'} = 'Rediger spørsmål';
    $Self->{Translation}->{'go back to questions'} = 'tilbake til spørsmålene';
    $Self->{Translation}->{'Possible Answers For'} = 'Mulige svaralternativer for';
    $Self->{Translation}->{'Add Answer'} = 'Legg til svaralternativer';
    $Self->{Translation}->{'No answers saved for this question.'} = '';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = '';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Dette spørsmålet har ikke mulighet for svaralternativer. Her vil det kun bli vist en tekstboks.';
    $Self->{Translation}->{'Go back'} = 'Gå tilbake';
    $Self->{Translation}->{'Edit Answer'} = 'Rediger svar';
    $Self->{Translation}->{'go back to edit question'} = 'gå tilbake for å redigere spørsmål';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Max antall spørreundersøkelser pr side';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Avsender av varsel-e-post';
    $Self->{Translation}->{'Notification Subject'} = 'Tittel i varsel-e-post';
    $Self->{Translation}->{'Notification Body'} = 'Melding i varsel-e-post';
    $Self->{Translation}->{'Changed By'} = 'Endret av';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = '';
    $Self->{Translation}->{'Requests Table'} = 'Tabellforespørsel';
    $Self->{Translation}->{'Send Time'} = 'Tid sendt';
    $Self->{Translation}->{'Vote Time'} = 'Tid svart';
    $Self->{Translation}->{'See Details'} = '';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detaljstatistikk for spørreundersøkelse';
    $Self->{Translation}->{'go back to stats overview'} = 'gå tilbake til statistikkoversikten';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informasjon om spørreundersøkelsen';
    $Self->{Translation}->{'Sent requests'} = 'Sendte forespørsler';
    $Self->{Translation}->{'Received surveys'} = 'Mottatte spørreundersøkelser';
    $Self->{Translation}->{'Survey Details'} = 'Detaljer om spørreundersøkelsen';
    $Self->{Translation}->{'Ticket Services'} = '';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafisk fremstilling av svarene i spørreundersøkelsen';
    $Self->{Translation}->{'No stat results.'} = 'Ingen resultater';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Spørreundersøkelse';
    $Self->{Translation}->{'Please answer these questions'} = '';
    $Self->{Translation}->{'Show my answers'} = '';
    $Self->{Translation}->{'These are your answers'} = '';
    $Self->{Translation}->{'Survey Title'} = '';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'En modul for spørreundersøkelser';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'En modul for å redigere spørreundersøkelser';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        '';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        '';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Standard melding i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Standard avsender i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Standard overskrift i varsel-e-post til kunder om en ny spørreundersøkelse.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        '';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        '';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        '';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        '';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        '';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = '';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        '';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Hvis denne regexen stemmer, vil det ikke bli sendt ut en spørreundersøkelse til kunden.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        '';
    $Self->{Translation}->{'Public Survey.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = '';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = '';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = '';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Standard identifikator for en undersøklse, f.eks. Spørreundersøkelse#, MinSpørreundersøkelse#. Standard er Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        '';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

}

1;
