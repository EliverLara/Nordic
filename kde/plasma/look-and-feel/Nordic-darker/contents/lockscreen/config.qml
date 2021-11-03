import QtQuick 2.5
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Layouts 1.1

ColumnLayout {
    property alias cfg_alwaysShowClock: alwaysClock.checked
    property alias cfg_showMediaControls: showMediaControls.checked

    spacing: 0

    RowLayout {
        spacing: units.largeSpacing / 2

        QQC2.Label {
            Layout.minimumWidth: formAlignment - units.largeSpacing //to match wallpaper config...
            horizontalAlignment: Text.AlignRight
            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Clock:")
        }
        QQC2.CheckBox {
            id: alwaysClock
            text: i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "verb, to show something", "Always show")
        }
        Item {
            Layout.fillWidth: true
        }
    }

    RowLayout {
        spacing: units.largeSpacing / 2

        QQC2.Label {
            Layout.minimumWidth: formAlignment - units.largeSpacing //to match wallpaper config...
            horizontalAlignment: Text.AlignRight
            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Media controls:")
        }
        QQC2.CheckBox {
            id: showMediaControls
            text: i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "verb, to show something", "Show")
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
