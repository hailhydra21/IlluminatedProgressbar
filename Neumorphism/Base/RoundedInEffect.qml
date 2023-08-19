// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
//import QtGraphicalEffects 1.0
//import Neumorphism 1.0

Item {
    id: control

    property alias shadow: shadowEffect.shadow
    property color color: "#f5f5f5"

    implicitWidth: 50
    implicitHeight: 50

    ShaderEffect {
        id: shadowEffect

        implicitWidth: parent.width
        implicitHeight: parent.height

        property Shadow shadow: Shadow {
            offset: 0
            radius: 0
            spread: 0
            angle: 45
            distance: 0.45
            color1: Qt.darker(control.color, 1.4)
            color2: Qt.lighter(control.color, 1.1)
        }

        readonly property vector2d ratio: Qt.vector2d(width / whmax, height / whmax)
        readonly property color color1: shadow.color1
        readonly property color color2: shadow.color2
        readonly property real whmax: Math.max(width, height)
        readonly property real spread: shadow.spread / whmax
        readonly property real offset: shadow.offset / whmax
        // Converts the angle of a shadow to a radian.
        readonly property real angle: shadow.angle * 0.0174533
        readonly property real shdiff: shadow.distance
        readonly property real smoothstp: 2 / whmax
        readonly property real radius: {
            const min = Math.min(width, height);
            return Math.min(Math.max(shadow.radius, spread), min/2) / whmax;
        }

        fragmentShader: "../../source/RoundedInEffect.frag.qsb"
    }
}
