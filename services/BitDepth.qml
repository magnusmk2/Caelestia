pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool is10Bit: true
    property string currentMode: "10bit"
    property bool isToggling: false
    property bool isTogglingMode: false // Track if we're checking state for toggle

    readonly property string toggleScript: "/home/magnus/.config/hypr/scripts/toggle-bitdepth.sh"

    // State verification process - checks actual monitor formats
    Process {
        id: stateCheckProc

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("BitDepth: Checking monitor formats...");

                // Count monitors in each format (based on Wayland format research)
                var format10bit = (text.match(/XBGR2101010|XRGB2101010/g) || []).length;
                var format8bit = (text.match(/XRGB8888/g) || []).length;
                var totalMonitors = 3; // We know we have 3 monitors

                console.log(`BitDepth: Found ${format10bit} monitors in 10-bit, ${format8bit} monitors in 8-bit`);

                // Determine consistent state (all monitors should match)
                if (format10bit === totalMonitors && format8bit === 0) {
                    root.is10Bit = true;
                    root.currentMode = "10bit";
                    console.log("BitDepth: All monitors in 10-bit mode");
                } else if (format8bit === totalMonitors && format10bit === 0) {
                    root.is10Bit = false;
                    root.currentMode = "8bit";
                    console.log("BitDepth: All monitors in 8-bit mode");
                } else {
                    console.warn(`BitDepth: Inconsistent state - ${format10bit} in 10-bit, ${format8bit} in 8-bit`);
                    // Default to 10-bit if mixed state
                    root.is10Bit = true;
                    root.currentMode = "10bit";
                }

                // If we're in toggle mode, now execute the toggle
                if (root.isTogglingMode) {
                    console.log("BitDepth: Verified state, now toggling from:", root.currentMode);
                    root.isTogglingMode = false;
                    toggleProc.command = [toggleScript, "toggle"];
                    toggleProc.running = true;
                }
            }
        }
    }

    // Monitor info display process
    Process {
        id: infoCheckProc

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("BitDepth: Parsing monitor info for display...");

                // Parse monitor information for user-friendly display
                var lines = text.split('\n');
                var infoLines = ["📺 Monitor Status"];

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (line.startsWith('Monitor ')) {
                        var monitorName = line.split(' ')[1];
                        var position = monitorName === 'DP-2' ? 'Left' :
                                      monitorName === 'DP-3' ? 'Middle' : 'Right';

                        // Look for format in next few lines
                        for (var j = i + 1; j < Math.min(i + 10, lines.length); j++) {
                            if (lines[j].trim().startsWith('currentFormat:')) {
                                var format = lines[j].split(': ')[1];
                                var bitdepth = format.includes('2101010') ? '10-bit' : '8-bit';
                                infoLines.push(`${position} (${monitorName}): ${bitdepth}`);
                                break;
                            }
                        }
                    }
                }

                // Send detailed notification
                notifyProc.command = ["notify-send", "Monitor Info",
                                     infoLines.join('\n'),
                                     "-i", "tv", "-t", "6000"];
                notifyProc.running = true;
            }
        }
    }

    Process {
        id: toggleProc

        onExited: function(exitCode, exitStatus) {
            console.log("BitDepth: Toggle script finished, exit code:", exitCode);
            root.isToggling = false;

            if (exitCode === 0) {
                // Toggle the state for UI responsiveness
                root.is10Bit = !root.is10Bit;
                root.currentMode = root.is10Bit ? "10bit" : "8bit";
                console.log("BitDepth: Successfully toggled to", root.currentMode);

                // Send short notification that replaces previous ones
                notifyProc.command = ["notify-send", "Display",
                                     root.is10Bit ? "10-bit mode" : "8-bit mode",
                                     "-i", "tv", "-t", "2000", "-r", "12345"];
                notifyProc.running = true;
            } else {
                console.error("BitDepth: Toggle script failed with exit code:", exitCode);

                // Send short error notification
                notifyProc.command = ["notify-send", "Display Error",
                                     "Toggle failed",
                                     "-i", "error", "-t", "3000"];
                notifyProc.running = true;
            }
        }
    }

    Process {
        id: notifyProc
    }



    function checkState(): void {
        console.log("BitDepth: Checking actual monitor state...");
        stateCheckProc.command = ["hyprctl", "monitors"];
        stateCheckProc.running = true;
    }

    function showMonitorInfo(): void {
        console.log("BitDepth: Showing detailed monitor information...");

        // Use the existing stateCheckProc but with different handling
        infoCheckProc.command = ["hyprctl", "monitors"];
        infoCheckProc.running = true;
    }

    function toggle(): void {
        if (isToggling) {
            console.log("BitDepth: Toggle already in progress, ignoring request");
            return;
        }

        console.log("BitDepth: Toggle requested, verifying current state first...");
        isToggling = true;
        isTogglingMode = true; // Flag that we're checking state for toggle

        // First verify actual state, then toggle
        stateCheckProc.command = ["hyprctl", "monitors"];
        stateCheckProc.running = true;
    }

    Component.onCompleted: {
        console.log("BitDepth: Service initializing, checking actual monitor state...");
        checkState();
    }
}
