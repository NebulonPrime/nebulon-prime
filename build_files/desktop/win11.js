// Windows 11 style: Start button and pinned apps centred, monitors/tray/clock on the right.
// The two flexible spacers keep the middle group centred as apps open and close.
const panel = newTaskbar(48);
panel.addWidget("org.kde.plasma.panelspacer");
addStartMenu(panel, "org.kde.plasma.kickoff");
addTaskList(panel, false);
panel.addWidget("org.kde.plasma.panelspacer");
addSystemMonitors(panel);
addTrayAndClock(panel);
