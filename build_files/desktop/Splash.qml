/*
 * Nebulon Prime login splash: the wallpaper, the logo and a progress bar.
 * KSplash raises `stage` from 1 to 6 while the desktop loads.
 */

import QtQuick

Rectangle {
    id: root
    color: "#0b0820"

    property int stage

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true;
        }
    }

    Image {
        anchors.fill: parent
        source: "file:///usr/share/wallpapers/NebulonPrime/contents/images/WALLPAPER_FILE"
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        Image {
            id: logo
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -height / 4
            source: "file:///usr/share/pixmaps/system-logo.png"
            sourceSize.width: 160
            sourceSize.height: 160
        }

        Text {
            id: name
            anchors.top: logo.bottom
            anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            text: "NEBULON PRIME"
            color: "#ffffff"
            font.pixelSize: 28
            font.letterSpacing: 8
            font.weight: Font.Light
        }

        Rectangle {
            id: track
            anchors.top: name.bottom
            anchors.topMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
            width: 240
            height: 4
            radius: 2
            color: "#33ffffff"

            Rectangle {
                height: parent.height
                radius: parent.radius
                width: parent.width * Math.min(root.stage, 6) / 6
                color: "#8b5cf6"
                Behavior on width {
                    NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutQuad
    }
}
