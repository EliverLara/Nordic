import QtQuick 2.2

import org.kde.plasma.core 2.0 as PlasmaCore

import QtQuick.Controls.Styles 1.4 as QQCS
import QtQuick.Controls 1.3 as QQC

QQCS.MenuStyle {
    frame: Rectangle {
        color: "#2e3440"
        border.color: "#232831"
        border.width: 1
    }
    itemDelegate.label: QQC.Label {
        height: contentHeight * 2
        verticalAlignment: Text.AlignVCenter
        color: config.highlight_color
        font.pointSize: config.fontSize
        font.family: config.font
        text: styleData.text
    }
    itemDelegate.background: Rectangle {
        visible: styleData.selected
        color: config.selected_color
    }
}
