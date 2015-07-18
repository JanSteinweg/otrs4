# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZAuto;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my ($File, $Self) = @_;
$Self->{'PostMaster::PreFilterModule::NewTicketReject::Body'} =  'Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team';
$Self->{'PostmasterMaxEmails'} =  '99';
$Self->{'Frontend::ToolBarModule'}->{'10-Ticket::TicketSearchFulltext'} =  {
  'Block' => 'ToolBarSearchFulltext',
  'CSS' => 'Core.Agent.Toolbar.FulltextSearch.css',
  'Description' => 'Fulltext search',
  'Module' => 'Kernel::Output::HTML::ToolBarGeneric',
  'Name' => 'Fulltext search',
  'Priority' => '1990020',
  'Size' => '10'
};
$Self->{'Frontend::ToolBarModule'}->{'9-Ticket::TicketSearchProfile'} =  {
  'Block' => 'ToolBarSearchProfile',
  'Description' => 'Search template',
  'MaxWidth' => '40',
  'Module' => 'Kernel::Output::HTML::ToolBarTicketSearchProfile',
  'Name' => 'Search template',
  'Priority' => '1990010'
};
$Self->{'Frontend::ToolBarModule'}->{'4-Ticket::AgentTicketPhone'} =  {
  'AccessKey' => '',
  'Action' => 'AgentTicketPhone',
  'CssClass' => 'PhoneTicket',
  'Icon' => 'fa fa-phone',
  'Link' => 'Action=AgentTicketPhone',
  'Module' => 'Kernel::Output::HTML::ToolBarLink',
  'Name' => 'New phone ticket',
  'Priority' => '1020010'
};
$Self->{'Frontend::ToolBarModule'}->{'3-Ticket::AgentTicketEscalation'} =  {
  'AccessKey' => 'w',
  'Action' => 'AgentTicketEscalationView',
  'CssClass' => 'EscalationView',
  'Icon' => 'fa fa-exclamation',
  'Link' => 'Action=AgentTicketEscalationView',
  'Module' => 'Kernel::Output::HTML::ToolBarLink',
  'Name' => 'Escalation view',
  'Priority' => '1010030'
};
$Self->{'Frontend::ToolBarModule'}->{'1-Ticket::AgentTicketQueue'} =  {
  'AccessKey' => 'q',
  'Action' => 'AgentTicketQueue',
  'CssClass' => 'QueueView',
  'Icon' => 'fa fa-folder',
  'Link' => 'Action=AgentTicketQueue',
  'Module' => 'Kernel::Output::HTML::ToolBarLink',
  'Name' => 'Queue view',
  'Priority' => '1010010'
};
$Self->{'Frontend::Module'}->{'AdminGenericInterfaceMappingSimple'} =  {
  'Description' => 'Admin',
  'Group' => [
    'admin'
  ],
  'Loader' => {
    'CSS' => [
      'Core.Agent.Admin.GenericInterface.css'
    ],
    'JavaScript' => [
      'Core.Agent.Admin.GenericInterfaceMappingSimple.js'
    ]
  },
  'Title' => 'GenericInterface Webservice Mapping GUI'
};
$Self->{'Frontend::Module'}->{'AdminGenericInterfaceDebugger'} =  {
  'Description' => 'Admin',
  'Group' => [
    'admin'
  ],
  'Loader' => {
    'CSS' => [
      'Core.Agent.Admin.GenericInterface.css'
    ],
    'JavaScript' => [
      'Core.Agent.Admin.GenericInterfaceDebugger.js'
    ]
  },
  'Title' => 'GenericInterface Debugger GUI'
};
$Self->{'OpenMainMenuOnHover'} =  '1';
delete $Self->{'PreferencesGroups'}->{'SpellDict'};
$Self->{'NotificationBodyLostPassword'} =  'Hi <OTRS_USERFIRSTNAME>,


Here\'s your new OTRS password.

New password: <OTRS_NEWPW>

You can log in via the following URL:

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl';
$Self->{'NotificationBodyLostPasswordToken'} =  'Hi <OTRS_USERFIRSTNAME>,

You or someone impersonating you has requested to change your OTRS
password.

If you want to do this, click on the link below. You will receive another email containing the password.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=LostPassword;Token=<OTRS_TOKEN>

If you did not request a new password, please ignore this email.';
$Self->{'TimeWorkingHours::Calendar1'} =  {
  'Fri' => [
    '8',
    '9',
    '10',
    '11',
    '13',
    '14',
    '15',
    '16',
    '17'
  ],
  'Mon' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ],
  'Sat' => [],
  'Sun' => [],
  'Thu' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ],
  'Tue' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ],
  'Wed' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ]
};
$Self->{'TimeZone::Calendar1Name'} =  'Work time m-f,8-18';
$Self->{'SendmailModule::AuthPassword'} =  'Otrs1234Otrs';
$Self->{'SendmailModule::AuthUser'} =  'otrs@steinwegs.de';
$Self->{'SendmailModule::Host'} =  'smtp.strato.de';
$Self->{'SendmailModule'} =  'Kernel::System::Email::SMTPTLS';
$Self->{'LogModule::LogFile'} =  'C:/dev/otrs/OTRS/var/log/otrs.log';
$Self->{'LogModule'} =  'Kernel::System::Log::File';
$Self->{'CheckMXRecord'} =  '0';
$Self->{'DefaultLanguage'} =  'de';
$Self->{'Organization'} =  'Steinwegs';
$Self->{'AdminEmail'} =  'otrs@steinwegs.de';
$Self->{'FQDN'} =  'tpdev03';
$Self->{'SystemID'} =  '42';
$Self->{'SecureMode'} =  '1';
}
1;
