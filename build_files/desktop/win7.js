// Windows 7 style: cascading classic Start menu (Application Menu) on the left, taller taskbar.
const panel = newTaskbar(52);
addStartMenu(panel, "org.kde.plasma.kicker");
addTaskList(panel, true);
addSystemMonitors(panel);
addTrayAndClock(panel);
