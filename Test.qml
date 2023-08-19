import QtQuick
import QtQuick.Templates as T
import "Neumorphism/Base"

T.ProgressBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                implicitContentHeight + topPadding + bottomPadding)

    width: 50
    height: 200

    property int extend: 60;

    Item {
        id: glow
        width: ibox.width + control.extend + 5
        height: ibox.height + 35

        anchors.right: ibox.right
        anchors.rightMargin: -18

        y: -45

        //visible: control.glowVisable

        ShaderEffect {
            id: shaderEffect

            width: parent.width
            height: parent.height

            readonly property color color: Qt.lighter("#f5f5f5", 2)
            readonly property int hasGradient: 0
            readonly property color c0: "#fff"
            readonly property color c1: "#fff"
            readonly property vector2d s0: Qt.vector2d(0.5, 1.0)
            readonly property vector2d s1: Qt.vector2d(0.5, 0.0)
            readonly property vector2d ratio: Qt.vector2d(width / Math.max(width, height),
                                                          height / Math.max(width, height));
            // 定义一个只读的二维向量属性，表示宽高比例
            readonly property vector2d iboxRatio: Qt.vector2d(ibox.width / Math.max(ibox.width, ibox.height),
                                                              ibox.height / Math.max(ibox.width, ibox.height));
            readonly property real radius: 0.5 * width / Math.max(width, height)
            readonly property real edgeOffset1: -0.1

            fragmentShader: "source/progressGlow.frag.qsb"
        }
    }

    Item {
        id: glow2
        width: ibox.width + control.extend
        height: ibox.height + 40

        anchors.left: ibox.left
        anchors.leftMargin: -18

        y: 10

        //visible: control.glowVisable

        ShaderEffect {
            id: shaderEffect2

            width: parent.width
            height: parent.height

            readonly property color color: Qt.darker("#c8e0ed", 1.1)
            readonly property int hasGradient: 0
            readonly property color c0: "#fff"
            readonly property color c1: "#fff"
            readonly property vector2d s0: Qt.vector2d(0.5, 1.0)
            readonly property vector2d s1: Qt.vector2d(0.5, 0.0)
            readonly property vector2d ratio: Qt.vector2d(width / Math.max(width, height),
                                                          height / Math.max(width, height));
            // 定义一个只读的二维向量属性，表示宽高比例
            readonly property vector2d iboxRatio: Qt.vector2d(ibox.width / Math.max(ibox.width, ibox.height),
                                                              ibox.height / Math.max(ibox.width, ibox.height));
            readonly property real radius: 0.5 * width / Math.max(width, height)
            readonly property real edgeOffset1: -0.05

            fragmentShader: "source/progressGlow.frag.qsb"
        }
    }

    Rectangle {
        id: ibox
        width: parent.width
        height: parent.height

        anchors.centerIn: parent

        radius: width / 2.0

        color: "#e2f1f9"
    }
}
