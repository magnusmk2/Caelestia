import QtQuick
import Quickshell
import qs.components
import qs.config

Item {
    id: root

    required property PersistentProperties visibilities

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight
    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                property: "implicitWidth"
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }

        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                property: "implicitWidth"
                easing.bezierCurve: root.visibilities.osd ? Appearance.anim.curves.expressiveDefaultSpatial : Appearance.anim.curves.emphasized
            }

        }
    ]

    Content {
        id: content

        visibilities: root.visibilities
    }

    states: State {
        name: "visible"
        when: root.visibilities.session && Config.session.enabled

        PropertyChanges {
            root.implicitWidth: content.implicitWidth
        }

    }

}
