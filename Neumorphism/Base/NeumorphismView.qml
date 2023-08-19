// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.12
import QtQuick.Controls 2.12

Control {
    id: control

    property Shadow shadow: Shadow {
        angle: 25
        radius: 10
        color1: Qt.darker(control.palette.base, 4.8)
        color2: Qt.lighter(control.palette.base, 3.9)
    }

    // QtObject类型是一个仅包含objectName属性的非可视元素
    QtObject {
        id: innerVars
        // 而57.2958是一个常数，它是180度除以π的结果。
        // 所以，这个属性声明的作用是将角度值转换为弧度值，因为一些数学函数需要使用弧度值作为参数
        readonly property real radianAngle: control.shadow.angle / 57.2958
    }

    // implicitWidth是一个控件的自然或默认宽度，而width是一个控件的实际宽度。
    width: contentItem.implicitWidth
    height: contentItem.implicitHeight

    background: Item {

        width: control.implicitContentWidth
        height: control.implicitContentHeight

        FastShadow {
            // http://blog.ivank.net/fastest-gaussian-blur.html
            x: Math.cos(innerVars.radianAngle)
            y: Math.sin(innerVars.radianAngle)
            width: parent.width
            height: parent.height
            radius: control.shadow.radius
            source: contentItem
            color: control.shadow.color1
        }

        FastShadow {
            x: 1.5 * Math.cos(innerVars.radianAngle + 3.14)
            y: 1.5 * Math.sin(innerVars.radianAngle + 3.14)
            width: parent.width
            height: parent.height
            radius: control.shadow.radius
            source: contentItem
            color: control.shadow.color2
        }
    }

    contentItem: Item {}
}
