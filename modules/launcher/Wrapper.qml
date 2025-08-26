import QtQuick
import Quickshell
import qs.components
import qs.config

Item {
    id: root

    required property PersistentProperties visibilities
    required property var panels

    visible: height > 0
    implicitHeight: 0
    implicitWidth: content.implicitWidth
    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                property: "implicitHeight"
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }

        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                property: "implicitHeight"
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }

        }
    ]

    Content {
        id: content

        wrapper: root
        visibilities: root.visibilities
        panels: root.panels
    }

    states: State {
        name: "visible"
        when: root.visibilities.launcher && Config.launcher.enabled

        PropertyChanges {
            root.implicitHeight: content.implicitHeight
        }

    }

}
