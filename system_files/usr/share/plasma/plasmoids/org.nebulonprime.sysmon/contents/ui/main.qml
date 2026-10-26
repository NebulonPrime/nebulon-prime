// Taskbar CPU and RAM monitor: "CPU 6%  RAM 23%", with exact amounts in the tooltip.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

PlasmoidItem {
    id: root

    Sensors.Sensor { id: cpu; sensorId: "cpu/all/usage"; updateRateLimit: 1500 }
    Sensors.Sensor { id: ramPercent; sensorId: "memory/physical/usedPercent"; updateRateLimit: 1500 }
    Sensors.Sensor { id: ramUsed; sensorId: "memory/physical/used"; updateRateLimit: 1500 }
    Sensors.Sensor { id: ramTotal; sensorId: "memory/physical/total" }

    function percent(sensor) {
        return isNaN(sensor.value) ? "–" : Math.round(sensor.value) + "%";
    }

    preferredRepresentation: fullRepresentation
    toolTipMainText: i18n("CPU and RAM use")
    toolTipSubText: i18n("CPU: %1\nRAM: %2 of %3", cpu.formattedValue, ramUsed.formattedValue, ramTotal.formattedValue)

    fullRepresentation: RowLayout {
        spacing: Kirigami.Units.largeSpacing
        // Fixed widths sized for "100%" so the taskbar doesn't shift as the numbers change
        Layout.minimumWidth: implicitWidth
        Layout.preferredWidth: implicitWidth

        TextMetrics { id: widest; text: "CPU 100%"; font: Kirigami.Theme.defaultFont }

        PlasmaComponents.Label {
            Layout.preferredWidth: widest.width
            text: i18n("CPU %1", root.percent(cpu))
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: widest.width
            text: i18n("RAM %1", root.percent(ramPercent))
        }
    }
}
