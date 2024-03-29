# --
# Kernel/Language/es_Survey.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Cambiar Estado -';
    $Self->{Translation}->{'Add New Survey'} = 'Añadir Nueva Encuesta';
    $Self->{Translation}->{'Survey Edit'} = 'Editar Encuesta';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Editar Preguntas de Estadística';
    $Self->{Translation}->{'Question Edit'} = 'Editar Pregunta';
    $Self->{Translation}->{'Answer Edit'} = 'Editar Respuesta';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'No se puede establecer nuevo estado! No hay preguntas definidas.';
    $Self->{Translation}->{'Status changed.'} = 'Estado cambiado.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Gracias por su retroalimentación';
    $Self->{Translation}->{'The survey is finished.'} = 'La encuesta ha terminado.';
    $Self->{Translation}->{'Complete'} = 'Completa';
    $Self->{Translation}->{'Incomplete'} = 'Incompleta';
    $Self->{Translation}->{'Checkbox (List)'} = 'Casilla de verificación (lista)';
    $Self->{Translation}->{'Radio'} = 'Opcion';
    $Self->{Translation}->{'Radio (List)'} = 'Opción (lista) ';
    $Self->{Translation}->{'Stats Overview'} = 'Resumen de Estadisticas';
    $Self->{Translation}->{'Survey Description'} = 'Descripción de la Encuesta';
    $Self->{Translation}->{'Survey Introduction'} = 'Introducción de la Encuesta';
    $Self->{Translation}->{'Yes/No'} = 'Si/No';
    $Self->{Translation}->{'YesNo'} = 'SiNo';
    $Self->{Translation}->{'answered'} = 'respondido';
    $Self->{Translation}->{'not answered'} = 'no respondido';
    $Self->{Translation}->{'Stats Detail'} = 'Detalle de Estadísticas';
    $Self->{Translation}->{'Stats Details'} = 'Detalle de Estadísticas';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Usted ya ha contestado esta encuesta.';
    $Self->{Translation}->{'Survey#'} = 'Encuesta#';
    $Self->{Translation}->{'- No queue selected -'} = '- No se ha seleccionado ninguna cola -';
    $Self->{Translation}->{'Master'} = 'Maestro';
    $Self->{Translation}->{'New Status'} = 'Nuevo Estado';
    $Self->{Translation}->{'Question Type'} = 'Tipo de Pregunta';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Crear Nueva Encuesta';
    $Self->{Translation}->{'Introduction'} = 'Introducción';
    $Self->{Translation}->{'Internal Description'} = 'Descripción Interna';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Editar información General';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Editar Preguntas';
    $Self->{Translation}->{'Add Question'} = 'Agregar Pregunta';
    $Self->{Translation}->{'Type the question'} = 'Escriba la pregunta';
    $Self->{Translation}->{'Answer required'} = 'Respuesta requerida';
    $Self->{Translation}->{'Survey Questions'} = 'Preguntas de Estadistica';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'No hay preguntas almacenadas para esta encuesta.';
    $Self->{Translation}->{'Question'} = 'Pregunta';
    $Self->{Translation}->{'Answer Required'} = 'Respuesta Requerida';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        'Cuando termine de editar las preguntas de la encienta solamente cierre esta ventana.';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        '¿Realmente desea eliminar esta pregunta? TODOS los datos asociados de PERDERÁN!';
    $Self->{Translation}->{'Edit Question'} = 'Editar Pregunta';
    $Self->{Translation}->{'go back to questions'} = 'regresar a preguntas';
    $Self->{Translation}->{'Possible Answers For'} = 'Posibles respuestas para';
    $Self->{Translation}->{'Add Answer'} = 'Agregar Respuesta';
    $Self->{Translation}->{'No answers saved for this question.'} = 'No hay respuestas almacenadas para esta pregunta.';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = '¿Realmente desea eliminar esta respuesta?';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Esta pregunta no tiene varias respuestas, un area de texto será mostrada';
    $Self->{Translation}->{'Go back'} = 'Regresar';
    $Self->{Translation}->{'Edit Answer'} = 'Editar Respuesta';
    $Self->{Translation}->{'go back to edit question'} = 'volver a editar pregunta';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Numero máximo de encuestas mostradas por página';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Remitente de Notificacion';
    $Self->{Translation}->{'Notification Subject'} = 'Asunto de Notificación';
    $Self->{Translation}->{'Notification Body'} = 'Cuerpo de Notificación';
    $Self->{Translation}->{'Changed By'} = 'Modificaco por';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Resumen de Estadísticas de';
    $Self->{Translation}->{'Requests Table'} = 'Tabla de Solicitudes';
    $Self->{Translation}->{'Send Time'} = 'Tiempo de Envío';
    $Self->{Translation}->{'Vote Time'} = 'Tiempo de Voto';
    $Self->{Translation}->{'See Details'} = 'Ver Detalles';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalles de Estadisticas de Encuesta';
    $Self->{Translation}->{'go back to stats overview'} = 'regresar a resúmen de estadisticas';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Información de Encuesta';
    $Self->{Translation}->{'Sent requests'} = 'Solicitudes enviadas';
    $Self->{Translation}->{'Received surveys'} = 'Solicitudes recibidas';
    $Self->{Translation}->{'Survey Details'} = 'Detalles de Encuesta';
    $Self->{Translation}->{'Ticket Services'} = 'Servicios de Tickets';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafica de Resultados de Encuesta';
    $Self->{Translation}->{'No stat results.'} = 'No hay graficas de resultados.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Encuesta';
    $Self->{Translation}->{'Please answer these questions'} = 'Por favor conteste estas preguntas';
    $Self->{Translation}->{'Show my answers'} = 'Mostrar mis respuestas';
    $Self->{Translation}->{'These are your answers'} = 'Estas son sus respuestas';
    $Self->{Translation}->{'Survey Title'} = 'Título de la Encuesta ';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Un Módulo de Encuestas.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Un módulo para editar las preguntas de una encuesta.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Todos los parametros para el objeto Encuesta en la interfase de agente.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Cantidad de días después de haber mandando un correo electrónico de encuesta en los que no se mandarán nuevas encuestas hacia el mismo cliente. Seleccionar 0 mandará nuevos correos electrónicos de encuesta siempre. ';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Cuerpo default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Remitente default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Asunto default para el email de notificación a los clientes sobre la encuesta.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Define una módulo resumen para mostrar la vista pequeña de la lista de encuestas.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Define la cantidad máxima de encuestas que se mandarán a un cliente cada 30 días. ( 0 significa que no hay un máximo, todas las encuestas serán enviadas).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Define la cantidad de horas que se necesitan para que el cierre de un ticket active el envío de una encuesta, ( 0 significa mandar inmediatamente después de cerrado).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Define la altura predefinida para la vista de texto enriquecido para los elementos de la pantall de detalle de estadisticas.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Define las columnas que se mostrarán en el resumen de encuestas. Esta opción no tienen ningún efecto en la posición de las columnas.';
    $Self->{Translation}->{'Edit Survey General Information'} = 'Editar Información General de la Encuesta';
    $Self->{Translation}->{'Edit Survey Questions'} = 'Editar Preguntas de la Encuesta';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Activa o desactiva la pantalla de "Mostrar Datos de Votos" en la interface pública para mostrar los resultados de una encuesta específica cuando un cliente quiere responder una encuesta por segunda vez.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Activa o desactiva la comprobación de la condición de envío para el servicio.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Activa o desactiva la comprobación de la condición de envío para el tipo de ticket.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Registro de módulo frontend SurveyAdd en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Registro de módulo frontend SurveyEdit en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Registro de módulo frontend SurveyStats en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Registro de módulo frontend SurveyZoom en la interface del agente.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Registro de módulo frontend PublicSurvey en la interface pública.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Si esta expresión regular concuerda, la encuesta no será enviada.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametros para las páginas (en que las encuestas son mostradas) de la vista de resumen pequeña.';
    $Self->{Translation}->{'Public Survey.'} = 'Encuesta Pública.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú de edición de una encuesta en su vista de detalle en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú de edición preguntas de una encuesta en su vista de detalle en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú para ir hacia atrás en vista de detalle de una encuesta en la interface del agente.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Muestra un vínculo en el menú para ir detalle de las estadísticas de una encuesta en su vista de detalle en la interface del agente.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Módulo de Edición de Encuesta.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Limite de la vista de resumen pequeña.';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Módulo de Stadísticas de Encuesta.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modulo de Detalle de Encuesta.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Límite de encientas por página para el Resumen de Encuesta "Pequeño"';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Las encuestas no de mandarán a las direcciones de correo electrónico aquí configuradas.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'El identificador para una encuesta, ejemplo Survey#, MySurvey#. Por defecto es Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Módulo de evento de ticket que manda correos electrónicos de encuestas hacia los clientes si un ticket es cerrado.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = 'Ir a los detalles de la Estadística';

}

1;
