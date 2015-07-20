What is NightDutyNotify?
=============

This is a PostMasterFilter to send a Notification to the DutyMailAddress where a Tickets is send outside the normal BusinessTime.
The Filter checkes the defined Calendar for vacations and TimeWorkingHours
When either its a vacation-day or its outside the worktime, then it searches for the just created Ticket and creates the Notification-Mail to 
the DutyMailAddress.

Here you can find my GitHub with my changes.
The Packages are in var\packages
[My GitHub](https://github.com/Retiebralanak/otrs4).

Settings
=============

NightDutyNotify::DutyEmail

- Duty Mail where the notifications are send to
 - Default -> jan@steinwegs.de (author)


NightDutyNotify::NightDutyCalendar

- Which Calendar should be checked if a Notifications should be send?
- Info: Duty time is, when there is no marked worktime in calendar
 - Default -> 1


NightDutyNotify::DutySubjectLength

- Shorten the MailSubject in the notification to this length
 - Default -> 20


NightDutyNotify::DutyBodyLines

- Shorten the MailBody to this count of Lines for the notification
 - Default -> 1 


NightDutyNotify::CreateHistory

- Define, if a HistoryEntry should be placed into the Ticket
 - Default -> Yes


PostMaster::PostFilterModule###001-NightDutyNotify

- Required, to activate the Filter