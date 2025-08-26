import QtQuick
import Quickshell
import qs.config

Item {
    id: root

    required property PersistentProperties visibilities
    required property Item panel

    visible: height > 0
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    Content {
        id: content

        visibilities: root.visibilities
        panel: root.panel
    }

}
