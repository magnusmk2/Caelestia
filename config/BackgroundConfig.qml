import Quickshell.Io

JsonObject {
    property bool enabled: true
    property DesktopClock desktopClock
    property Visualiser visualiser

    desktopClock: DesktopClock {
    }

    visualiser: Visualiser {
    }

    component DesktopClock: JsonObject {
        property bool enabled: false
    }

    component Visualiser: JsonObject {
        property bool enabled: true
        property bool autoHide: true
        property real rounding: 1
        property real spacing: 1
    }

}
