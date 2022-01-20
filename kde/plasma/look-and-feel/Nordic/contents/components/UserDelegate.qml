/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.8
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: wrapper

    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    property int fontSize: config.fontSize
    signal clicked()

    property real faceSize: units.gridUnit * 7

    opacity: isCurrent ? 1.0 : 0.5

    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }

    // Draw a translucent background circle under the user picture
    Rectangle {
        anchors.centerIn: imageSource
        width: imageSource.width + 4 // Subtract to prevent fringing
        height: width
        radius: width / 2
        color: "#232831"
    }
    Rectangle {
        anchors.centerIn: imageSource
        width: imageSource.width + 10 // Subtract to prevent fringing
        height: width
        radius: width / 2
        color: "#8fbcbb"
        opacity: 0.6
        z:-1
    }


    Item {
        id: imageSource
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }
        Behavior on width { 
            PropertyAnimation {
                from: faceSize
                duration: units.longDuration;
            }
        }
        width: isCurrent ? faceSize : faceSize - units.largeSpacing
        height: width

        //Image takes priority, taking a full path to a file, if that doesn't exist we show an icon
        Image {
            id: face
            source: wrapper.avatarPath
            sourceSize: Qt.size(faceSize, faceSize)
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }

        PlasmaCore.IconItem {
            id: faceIcon
            source: iconSource
            visible: (face.status == Image.Error || face.status == Image.Null)
            anchors.fill: parent
            anchors.margins: units.gridUnit * 0.5 // because mockup says so...
            colorGroup: PlasmaCore.ColorScope.colorGroup
        }
    }

    ShaderEffect {
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }

        width: imageSource.width
        height: imageSource.height

        supportsAtlasTextures: true

        property var source: ShaderEffectSource {
            sourceItem: imageSource
            // software rendering is just a fallback so we can accept not having a rounded avatar here
            hideSource: wrapper.GraphicsInfo.api !== GraphicsInfo.Software
            live: true // otherwise the user in focus will show a blurred avatar
        }

        property var colorBorder: "#00000000"

        //draw a circle with an antialiased border
        //innerRadius = size of the inner circle with contents
        //outerRadius = size of the border
        //blend = area to blend between two colours
        //all sizes are normalised so 0.5 == half the width of the texture

        //if copying into another project don't forget to connect themeChanged to update()
        //but in SDDM that's a bit pointless
        fragmentShader: "
                        varying highp vec2 qt_TexCoord0;
                        uniform highp float qt_Opacity;
                        uniform lowp sampler2D source;

                        uniform lowp vec4 colorBorder;
                        highp float blend = 0.01;
                        highp float innerRadius = 0.47;
                        highp float outerRadius = 0.49;
                        lowp vec4 colorEmpty = vec4(0.0, 0.0, 0.0, 0.0);

                        void main() {
                            lowp vec4 colorSource = texture2D(source, qt_TexCoord0.st);

                            highp vec2 m = qt_TexCoord0 - vec2(0.5, 0.5);
                            highp float dist = sqrt(m.x * m.x + m.y * m.y);

                            if (dist < innerRadius)
                                gl_FragColor = colorSource;
                            else if (dist < innerRadius + blend)
                                gl_FragColor = mix(colorSource, colorBorder, ((dist - innerRadius) / blend));
                            else if (dist < outerRadius)
                                gl_FragColor = colorBorder;
                            else if (dist < outerRadius + blend)
                                gl_FragColor = mix(colorBorder, colorEmpty, ((dist - outerRadius) / blend));
                            else
                                gl_FragColor = colorEmpty ;

                            gl_FragColor = gl_FragColor * qt_Opacity;
                    }
        "
    }

    PlasmaComponents.Label {
        id: usernameDelegate
        font.pointSize: Math.max(fontSize + 2,theme.defaultFont.pointSize + 2)
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        width: constrainText ? parent.width : implicitWidth
        text: wrapper.name
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        //make an indication that this has active focus, this only happens when reached with keyboard navigation
        font.underline: wrapper.activeFocus
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
