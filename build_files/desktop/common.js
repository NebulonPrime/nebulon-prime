// Shared pieces for the Nebulon Prime desktop layouts. Each layout script is this file
// followed by the layout's own code (concatenated at build time by 60-desktop-layouts.sh).

const WALLPAPER = "file:///usr/share/wallpapers/NebulonPrime/";

const PINNED_APPS = [
    "preferred://filemanager",
    "preferred://browser",
    "applications:io.github.kolunmi.Bazaar.desktop",
    "applications:systemsettings.desktop",
];

function setWallpaper() {
    const all = desktops();
    for (let i = 0; i < all.length; ++i) {
        const d = all[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
        d.writeConfig("Image", WALLPAPER);
    }
}

function newTaskbar(height) {
    const panel = new Panel();
    panel.location = "bottom";
    panel.height = height;
    panel.floating = false; // Windows taskbars sit flush with the screen edge
    return panel;
}

function addStartMenu(panel, applet) {
    const menu = panel.addWidget(applet);
    menu.currentConfigGroup = ["General"];
    menu.writeConfig("icon", "distributor-logo");
    menu.currentConfigGroup = ["Shortcuts"];
    menu.writeConfig("global", "Alt+F1");
    return menu;
}

function addTaskList(panel, fill) {
    const tasks = panel.addWidget("org.kde.plasma.icontasks");
    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("launchers", PINNED_APPS);
    tasks.writeConfig("fill", fill);
    return tasks;
}

// CPU and RAM use, shown as live numbers in the taskbar
function addSystemMonitors(panel) {
    const monitors = ["org.kde.plasma.systemmonitor.cpu", "org.kde.plasma.systemmonitor.memory"];
    for (let i = 0; i < monitors.length; ++i) {
        const w = panel.addWidget(monitors[i]);
        w.currentConfigGroup = ["Appearance"];
        w.writeConfig("chartFace", "org.kde.ksysguard.textonly");
    }
}

function addTrayAndClock(panel) {
    panel.addWidget("org.kde.plasma.systemtray");
    const clock = panel.addWidget("org.kde.plasma.digitalclock");
    clock.currentConfigGroup = ["Appearance"];
    clock.writeConfig("showDate", true);
    clock.writeConfig("dateDisplayFormat", "BelowTime");
    panel.addWidget("org.kde.plasma.showdesktop");
}

setWallpaper();
