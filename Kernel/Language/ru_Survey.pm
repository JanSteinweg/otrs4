# --
# Kernel/Language/ru_Survey.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Изменить состояние -';
    $Self->{Translation}->{'Add New Survey'} = 'Добавить новый опрос';
    $Self->{Translation}->{'Survey Edit'} = 'Редактировать опрос';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Редактировать вопрос в опросе';
    $Self->{Translation}->{'Question Edit'} = 'Редактировать вопрос';
    $Self->{Translation}->{'Answer Edit'} = 'Редактировать ответ';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Нельзя задать новое состояние! Никакие вопросы не выделены.';
    $Self->{Translation}->{'Status changed.'} = 'Изменить состояние.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Спасибо за Ваши ответы.';
    $Self->{Translation}->{'The survey is finished.'} = 'Опрос завершен.';
    $Self->{Translation}->{'Complete'} = 'Завершенный';
    $Self->{Translation}->{'Incomplete'} = 'Незавершенный';
    $Self->{Translation}->{'Checkbox (List)'} = 'Галочки (Список)';
    $Self->{Translation}->{'Radio'} = 'Точки';
    $Self->{Translation}->{'Radio (List)'} = 'Точки (Список)';
    $Self->{Translation}->{'Stats Overview'} = 'Обзор статистики';
    $Self->{Translation}->{'Survey Description'} = 'Описание опроса';
    $Self->{Translation}->{'Survey Introduction'} = 'Знакомство с опросом';
    $Self->{Translation}->{'Yes/No'} = 'Да/Нет';
    $Self->{Translation}->{'YesNo'} = 'Да или Нет';
    $Self->{Translation}->{'answered'} = 'ответили';
    $Self->{Translation}->{'not answered'} = 'не ответили';
    $Self->{Translation}->{'Stats Detail'} = 'Подробный отчет';
    $Self->{Translation}->{'Stats Details'} = 'Подробности отчета';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Вы уже ответили на опрос.';
    $Self->{Translation}->{'Survey#'} = 'Опрос №';
    $Self->{Translation}->{'- No queue selected -'} = '- Ни одной очереди не выбрано -';
    $Self->{Translation}->{'Master'} = 'Главный';
    $Self->{Translation}->{'New Status'} = 'Новое состояние';
    $Self->{Translation}->{'Question Type'} = 'Тип вопроса';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Создать новый опрос';
    $Self->{Translation}->{'Introduction'} = 'Описание';
    $Self->{Translation}->{'Internal Description'} = 'Внутреннее описание';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Редактировать общую информацию';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Редактировать вопросы';
    $Self->{Translation}->{'Add Question'} = 'Добавть вопрос';
    $Self->{Translation}->{'Type the question'} = 'Вопрос и тип вопроса';
    $Self->{Translation}->{'Answer required'} = 'Требуются ответы';
    $Self->{Translation}->{'Survey Questions'} = 'Вопросы опроса';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Сохраненых вопросов нет.';
    $Self->{Translation}->{'Question'} = 'Вопрос';
    $Self->{Translation}->{'Answer Required'} = 'Требуются Ответы';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        'По окончании редактирования опроса просто закройте окно.';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'ы действительно хотите удалить этот вопрос?  ВСЕ связанные данные будут ПОТЕРЯНЫ!';
    $Self->{Translation}->{'Edit Question'} = 'Редактировать вопрос';
    $Self->{Translation}->{'go back to questions'} = 'назад к вопросам';
    $Self->{Translation}->{'Possible Answers For'} = 'Возможные ответы для';
    $Self->{Translation}->{'Add Answer'} = 'Добавить ответ';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Не заданы варианты ответов для этого вопроса.';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Вы действительно желаете удалить  этот ответ?';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Этот вопрос не предусматривает несколько ответов, будет показано текстовое/textarea поле.';
    $Self->{Translation}->{'Go back'} = 'Назад';
    $Self->{Translation}->{'Edit Answer'} = 'Редактировать ответ';
    $Self->{Translation}->{'go back to edit question'} = 'назад к редактированию вопроса';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Макс. кол-во Опросов на страницу';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Отправитель уведомления';
    $Self->{Translation}->{'Notification Subject'} = 'Тема уведомления';
    $Self->{Translation}->{'Notification Body'} = 'Тело уведомления';
    $Self->{Translation}->{'Changed By'} = 'Изменивший';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Подробности опроса';
    $Self->{Translation}->{'Requests Table'} = 'Таблица ответов';
    $Self->{Translation}->{'Send Time'} = 'Время отправки';
    $Self->{Translation}->{'Vote Time'} = 'Время ответа';
    $Self->{Translation}->{'See Details'} = 'См. подробности';
    $Self->{Translation}->{'Survey Stat Details'} = 'Подробности опроса';
    $Self->{Translation}->{'go back to stats overview'} = 'назад';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Информация по опросу';
    $Self->{Translation}->{'Sent requests'} = 'Отправленные запросы';
    $Self->{Translation}->{'Received surveys'} = 'Полученные опросы';
    $Self->{Translation}->{'Survey Details'} = 'Информаия по опросу';
    $Self->{Translation}->{'Ticket Services'} = 'Сервисы заявок';
    $Self->{Translation}->{'Survey Results Graph'} = 'Результаты опроса в графике';
    $Self->{Translation}->{'No stat results.'} = 'Статистики нет.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Опросы';
    $Self->{Translation}->{'Please answer these questions'} = 'Ответьте на эти вопросы:';
    $Self->{Translation}->{'Show my answers'} = 'Показать мои ответы';
    $Self->{Translation}->{'These are your answers'} = 'Ваши ответы';
    $Self->{Translation}->{'Survey Title'} = 'Название опроса';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Модуль Опросы.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Модуль для редактирования вопросов для опросов.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Все параметры для объекта Опросы в интерфейсе агента.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Количество дней, после отсылки писем с опросом, в течение которых никакие новые предложения об опросе не посылаются, одному и тому же клиенту. Выбор значения 0 указывает всегда посылать письмо с опросом.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Задает текст письма в почтовом уведомлении, посылаемом клиентам, о новом опросе.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Отправитель по умолчанию для электронной почты в новом опросе.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Тема по умолчанию для электронной почты в новом опросе.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Задает модуль просмотра для отображения списка опросов в small формате.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Задает максимальное количество опросов отсылаемых клиенту за каждые 30 дней. ("0" означает, что все запросы опросов будут отсылаться).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Задает число часов, после закрытия заявки, по истечении которых будет отправлено сообщение с опросом, ("0" означает немедленную отправку после закрытия). ';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Задает высоту по умолчанию области форматированного текста для элементов опроса при подробном просмотре.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Задает перечень колонок, отображаемых в обзоре Опросов. Этот параметр не влияет на порядок колонок.';
    $Self->{Translation}->{'Edit Survey General Information'} = 'Редактировать Общее описание опроса';
    $Self->{Translation}->{'Edit Survey Questions'} = 'Редактировать вопросы опроса';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Включите или отключить кнопку "Показать мои ответы", чтобы показать данные определенного результата опроса, когда клиент попытается ответить на опрос во второй раз.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Включить или отключить проверку условия отправки для сервиса.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Включить или отключить проверку условия отправки для типа заявки.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Frontend module registration для добавления опроса в интерфейса агента.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Frontend module registration для редактирования опроса в интерфейса агента.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Frontend module registration для модуля отчетности об опросе в интерфейса агента.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend module registration для подробного просмотра опроса в интерфейса агента.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend module registration для объекта Публичного опроса в разделе публичных опросов.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Если это регулярное выражение верно, опрос клиенту не посылается.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Параметры страницы (на которой отображаются опросы) при обзоре опросов в small формате.';
    $Self->{Translation}->{'Public Survey.'} = 'Общедоступный опрос.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Показывает пункт меню, позволяющий редактировать опрос при его подробном просмотре в интерфейсе агента.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Показывает пункт меню, позволяющий редактировать вопросы опроса при его подробном просмотре в интерфейсе агента.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Показывает пункт меню, позволяющий вернуться назад при просмотре опроса в интерфейсе агента.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Показывает пункт меню, позволяющий увидеть подробности отчета об опросе при его детальном просмотре в интерфейсе агента.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Модуль редактирования опроса.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Количество записей, отображаемых при просмотре опросов в "Small" формате';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Модуль построения отчетов об опросах.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Модуль подробного просмотра опросов.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Количество записей, отображаемых на странице при просмотре опросов в "Small" формате';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Опросы не будут отправляться на указанные почтовые адреса.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Обозначение для идентификации опроса, например, Опрос№, Survey#, MySurvey#. По умолчанию Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Модуль управления событием для заявки, автоматически отправляющий письмо клиенту с опросом, при закрытии заявки.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = 'Подробная информация по статистике';

}

1;
