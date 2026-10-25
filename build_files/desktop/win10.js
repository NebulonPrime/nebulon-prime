// Windows 10 style: Start button on the far left, apps filling the bar, tray/clock on the right.
const panel = newTaskbar(44);
addStartMenu(panel, "org.kde.plasma.kickoff");
addTaskList(panel, true);
addSystemMonitors(panel);
addTrayAndClock(panel);
