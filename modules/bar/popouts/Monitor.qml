pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property bool refreshing: false
    property var monitorData: []

    spacing: Appearance.spacing.small
    width: Config.bar.sizes.monitorWidth

    // Control buttons row
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Appearance.spacing.small
        spacing: Appearance.spacing.small

        // BitDepth toggle button (Caelestia theme colors with StateLayer)
        StyledRect {
            implicitWidth: 40
            implicitHeight: 40

            radius: Appearance.rounding.full
            color: BitDepth.is10Bit ? Colours.palette.m3primaryContainer : Colours.tPalette.m3surfaceContainer

            StateLayer {
                color: BitDepth.is10Bit ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface

                function onClicked(): void {
                    console.log("Monitor: BitDepth toggle clicked, current state:", BitDepth.is10Bit);
                    BitDepth.toggle();
                }
            }

            MaterialIcon {
                anchors.centerIn: parent
                animate: true
                text: BitDepth.is10Bit ? "tv" : "tv_off"
                color: BitDepth.is10Bit ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                font.pointSize: Appearance.font.size.normal
            }

            // Tooltip
            StyledText {
                visible: parent.children[0].containsMouse
                text: BitDepth.is10Bit ? "Switch to 8-bit color depth" : "Switch to 10-bit color depth"
                color: Colours.palette.m3onSurface
                font.pointSize: Appearance.font.size.tiny

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                anchors.topMargin: Appearance.spacing.smaller

                z: 1000
            }
        }

        // Identify monitors button (Caelestia theme colors with StateLayer)
        StyledRect {
            implicitWidth: 40
            implicitHeight: 40

            radius: Appearance.rounding.full
            color: Colours.palette.m3secondaryContainer

            StateLayer {
                color: Colours.palette.m3onSecondaryContainer

                function onClicked(): void {
                    console.log("Monitor: Identify monitors clicked");
                    showIdentifyPopups();
                }
            }

            MaterialIcon {
                anchors.centerIn: parent
                animate: true
                text: "search"
                color: Colours.palette.m3onSecondaryContainer
                font.pointSize: Appearance.font.size.normal
            }

            // Tooltip
            StyledText {
                visible: parent.children[0].containsMouse
                text: "Identify monitors"
                color: Colours.palette.m3onSurface
                font.pointSize: Appearance.font.size.tiny

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                anchors.topMargin: Appearance.spacing.smaller

                z: 1000
            }
        }
    }

    // Parse monitor information on component load and hover (research-based)
    Component.onCompleted: {
        parseMonitorData();
    }

    // Event-driven refresh: Monitor BitDepth changes (research-based)
    Connections {
        target: BitDepth

        function onIs10BitChanged() {
            console.log("Monitor: BitDepth changed to", BitDepth.is10Bit ? "10-bit" : "8-bit", "- refreshing monitor data...");
            parseMonitorData();
        }

        function onCurrentModeChanged() {
            console.log("Monitor: BitDepth mode changed to", BitDepth.currentMode, "- refreshing monitor data...");
            parseMonitorData();
        }
    }

    // Function to parse hyprctl monitors output (research-based: proper QuickShell Process)
    function parseMonitorData(): void {
        console.log("Monitor: Starting monitor data parsing...");
        monitorParseProc.running = true;
    }

    // Research-based: Hover area for refresh on mouse over
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        onEntered: {
            console.log("Monitor: Mouse entered, refreshing monitor data...");
            parseMonitorData();
        }

        onExited: {
            console.log("Monitor: Mouse exited");
        }
    }

    // Helper function to determine monitor position (research-based)
    function getMonitorPosition(name: string): string {
        switch (name) {
            case 'DP-2': return 'Left';
            case 'DP-3': return 'Middle';
            case 'DP-1': return 'Right';
            default: return name;
        }
    }

    // Identify monitors function - shows popups on each monitor
    function showIdentifyPopups() {
        console.log("Monitor: Creating identify popups for", root.monitorData.length, "monitors");

        for (let i = 0; i < root.monitorData.length; i++) {
            const monitor = root.monitorData[i];
            console.log("Monitor: Creating identify popup for", monitor.name);

            // Create identify popup component
            identifyPopupComponent.createObject(null, {
                monitorName: monitor.name,
                monitorModel: monitor.model,
                monitorResolution: monitor.resolution,
                monitorRefreshRate: monitor.refreshRate,
                monitorPosition: monitor.position,
                monitorColorDepth: monitor.colorDepth,
                monitorHdr: monitor.hdr
            });
        }
    }

    // Monitor data parsing process (research-based: QuickShell StdioCollector pattern)
    Process {
        id: monitorParseProc

        command: ["hyprctl", "monitors"]
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Monitor: Raw hyprctl output received, length:", text.length);
                console.log("Monitor: First 200 chars:", text.substring(0, 200));

                const monitors = [];
                const lines = text.split('\n');
                let currentMonitor = {};

                console.log("Monitor: Processing", lines.length, "lines");

                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i].trim();

                    if (line.startsWith('Monitor ')) {
                        // Save previous monitor
                        if (currentMonitor.name) {
                            console.log("Monitor: Saving monitor:", JSON.stringify(currentMonitor));
                            monitors.push(currentMonitor);
                        }

                        // Parse monitor name: "Monitor DP-1 (ID 0):"
                        const match = line.match(/Monitor (\S+) \(ID \d+\):/);
                        if (match) {
                            console.log("Monitor: Found monitor:", match[1]);
                            currentMonitor = {
                                name: match[1],
                                position: getMonitorPosition(match[1])
                            };
                        }
                    } else if (line.includes('@') && line.includes('x') && !line.includes('availableModes')) {
                        // Parse resolution and refresh rate: "2560x1440@164.05600 at 5280x0"
                        const resMatch = line.match(/(\d+x\d+)@([\d.]+)/);
                        if (resMatch) {
                            console.log("Monitor: Found resolution:", resMatch[1], "at", Math.round(parseFloat(resMatch[2])), "Hz");
                            currentMonitor.resolution = resMatch[1];
                            currentMonitor.refreshRate = Math.round(parseFloat(resMatch[2]));
                        }
                    } else if (line.startsWith('model:')) {
                        // Parse model: "model: DELL S3220DGF" or "model: PG42UQ"
                        const model = line.split(': ')[1] || 'Unknown';
                        console.log("Monitor: Found model:", model);
                        currentMonitor.model = model;
                    } else if (line.startsWith('currentFormat:')) {
                        // Parse color format: "currentFormat: XBGR2101010"
                        const format = line.split(': ')[1];
                        const colorDepth = format.includes('2101010') ? 10 : 8;
                        console.log("Monitor: Found format:", format, "-> depth:", colorDepth);
                        currentMonitor.colorDepth = colorDepth;
                        currentMonitor.hdr = format.includes('2101010');
                    }
                }

                // Add last monitor
                if (currentMonitor.name) {
                    console.log("Monitor: Saving final monitor:", JSON.stringify(currentMonitor));
                    monitors.push(currentMonitor);
                }

                console.log("Monitor: Final parsed data:", JSON.stringify(monitors, null, 2));

                // Research-based: Reassign array to trigger Repeater model update
                root.monitorData = monitors;
                console.log("Monitor: Successfully parsed", monitors.length, "monitors and updated model");
            }
        }
    }



    // Button Row (research-based: clean row of round buttons)
    RowLayout {
        Layout.fillWidth: true
        Layout.rightMargin: Appearance.padding.small
        spacing: Appearance.spacing.small



        // Spacer for future buttons
        Item {
            Layout.fillWidth: true
        }
    }





    // Individual Monitor Cards (research-based: real monitor data parsing)
    Repeater {
        model: root.monitorData

        ColumnLayout {
            id: monitorItem

            required property var modelData

            Layout.fillWidth: true
            Layout.rightMargin: Appearance.padding.small
            spacing: Appearance.spacing.smaller

            opacity: 0
            scale: 0.7

            Component.onCompleted: {
                console.log("Monitor: Creating monitor card for:", JSON.stringify(modelData));
                opacity = 1;
                scale = 1;
            }

            Behavior on opacity {
                Anim {}
            }

            Behavior on scale {
                Anim {}
            }

            // Monitor Header
            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.small

                MaterialIcon {
                    text: "monitor"
                    color: Colours.palette.m3primary
                }

                StyledText {
                    Layout.fillWidth: true
                    text: monitorItem.modelData.name || "Unknown Monitor"
                    font.weight: 500
                }

                MaterialIcon {
                    text: "more_horiz"
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                }
            }

            // Monitor Details (research-based: your requested format)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Appearance.padding.large
                spacing: Appearance.spacing.smaller / 2

                StyledText {
                    text: monitorItem.modelData.model
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                }

                StyledText {
                    text: qsTr("%1 @ %2Hz").arg(monitorItem.modelData.resolution).arg(monitorItem.modelData.refreshRate)
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                }

                StyledText {
                    text: qsTr("%1-bit color").arg(monitorItem.modelData.colorDepth)
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                }

                StyledText {
                    text: qsTr("HDR: %1").arg(monitorItem.modelData.hdr ? "Enabled" : "Disabled")
                    color: monitorItem.modelData.hdr ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                    font.pointSize: Appearance.font.size.small
                }
            }
        }
    }

    // Refresh Timer
    Timer {
        id: refreshTimer
        interval: 2000
        onTriggered: root.refreshing = false
    }

    // Identify popup component (research-based: FloatingWindow pattern)
    Component {
        id: identifyPopupComponent

        FloatingWindow {
            id: identifyWindow

            // Monitor info properties
            property string monitorName
            property string monitorModel
            property string monitorResolution
            property int monitorRefreshRate
            property string monitorPosition
            property int monitorColorDepth
            property bool monitorHdr

            // Window properties - find the correct screen
            screen: {
                for (let i = 0; i < Quickshell.screens.length; i++) {
                    const s = Quickshell.screens[i];
                    if (s.name === monitorName) {
                        console.log("Monitor: Found screen for", monitorName, ":", s.name);
                        return s;
                    }
                }
                console.log("Monitor: Screen not found for", monitorName, "using first screen");
                return Quickshell.screens[0];
            }

            visible: true
            title: `Monitor ${monitorName} - ${monitorModel}`

            // Size (research-based: use implicitWidth/Height instead of width/height)
            implicitWidth: 320
            implicitHeight: 220

            color: Colours.tPalette.m3surfaceContainer

            // Auto-close after 5 seconds (research-based: Caelestia Timer pattern)
            Timer {
                id: autoCloseTimer
                interval: 5000
                running: true
                repeat: false

                onTriggered: {
                    console.log("Monitor: Timer triggered for", monitorName, "- closing popup");
                    identifyWindow.destroy();
                }
            }

            Component.onCompleted: {
                console.log("Monitor: Identify popup created for", monitorName, "on screen:", screen?.name || "unknown");
                console.log("Monitor: Timer started - will close in", autoCloseTimer.interval, "ms");
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Appearance.padding.large
                spacing: Appearance.spacing.small

                // Monitor name/ID
                StyledText {
                    text: monitorName
                    font.pointSize: Appearance.font.size.large
                    font.weight: Font.Bold
                    color: Colours.palette.m3primary
                    Layout.alignment: Qt.AlignHCenter
                }

                // Monitor model
                StyledText {
                    text: monitorModel
                    font.pointSize: Appearance.font.size.normal
                    color: Colours.palette.m3onSurface
                    Layout.alignment: Qt.AlignHCenter
                }

                // Resolution and refresh rate
                StyledText {
                    text: `${monitorResolution} @ ${monitorRefreshRate}Hz`
                    font.pointSize: Appearance.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                    Layout.alignment: Qt.AlignHCenter
                }

                // Position
                StyledText {
                    text: `Position: ${monitorPosition}`
                    font.pointSize: Appearance.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                    Layout.alignment: Qt.AlignHCenter
                }

                // Color depth and HDR
                StyledText {
                    text: `${monitorColorDepth}-bit ${monitorHdr ? "HDR" : "SDR"}`
                    font.pointSize: Appearance.font.size.small
                    color: monitorHdr ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                    Layout.alignment: Qt.AlignHCenter
                }

                Item { Layout.fillHeight: true }

                // Auto-close message
                StyledText {
                    text: "This popup will close automatically"
                    font.pointSize: Appearance.font.size.tiny
                    color: Colours.palette.m3outline
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

}
