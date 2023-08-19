import QtQuick
//import Qt5Compat.GraphicalEffects
import QtQuick.Templates as T
import "Neumorphism/Base/"

T.ProgressBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    width: 50
    height: 200

    property int orientation: Qt.Vertical
    property color color1: "#f676e2"
    property color color2: "#fa8bab"
    property real edgeOffset1: 0.0
    property int margin: 20
    property bool glowVisable: true

    QtObject {
        id: orientation
        property bool vertical: control.orientation == Qt.Vertical
        property bool horizontal: control.orientation == Qt.Horizontal
    }

    contentItem: Item {
        id: progress

        implicitWidth: bkground.implicitWidth
        implicitHeight: bkground.implicitHeight

        property real spread: 80

        Rectangle {
            id: ibox
            width: parent.width - control.margin
            height: (parent.height - control.margin) * control.position

            anchors.bottom: parent.bottom
            anchors.bottomMargin: margin/2
            anchors.horizontalCenter: parent.horizontalCenter

            radius: width / 2.0
            //visible: true
            visible: false

            gradient: Gradient {
                // GradientStop表示渐变的停止点，position表示位置，color表示颜色
                GradientStop { position: 1.0; color: color1 }
                GradientStop { position: 0.0; color: color2 }
            }
        }

        ShaderEffectSource {
            id: iboxClip
            //visible: false

            width: ibox.width
            height: ibox.height
            // height: orientation.horizontal ? ibox.height : (ibox.height+2) * control.position

            property real clipHeight: orientation.vertical ? ibox.height * (1.0 - control.position) : 0
            property real clipWidth: orientation.horizontal ? ibox.width * (1.0 - control.position) : 0

            sourceItem: ibox
            // sourceRect: orientation.horizontal ? Qt.rect(0, 0, width, height) : Qt.rect(0, clipHeight, width, height)

            anchors.bottom: parent.bottom
            anchors.bottomMargin: margin / 2.0 - 2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: glow
            width: ibox.width + progress.spread
            height: ibox.height + progress.spread - 10

            anchors.centerIn: ibox

            visible: control.glowVisable

            ShaderEffect {
                id: shaderEffect

                width: parent.width
                height: parent.height

                readonly property color color: "#ffffff"
                readonly property int hasGradient: 1
                readonly property color c0: color1
                readonly property color c1: color2
                readonly property vector2d s0: Qt.vector2d(0.5, 1.0)
                readonly property vector2d s1: Qt.vector2d(0.5, 0.0)
                readonly property vector2d ratio: Qt.vector2d(width / Math.max(width, height),
                                                              height / Math.max(width, height));
                // 定义一个只读的二维向量属性，表示宽高比例
                readonly property vector2d iboxRatio: Qt.vector2d(ibox.width / Math.max(ibox.width, ibox.height),
                                                                  ibox.height / Math.max(ibox.width, ibox.height));
                readonly property real radius: 0.5 * width / Math.max(width, height)
                readonly property real edgeOffset1: control.edgeOffset1

                fragmentShader: "source/progressGlow.frag.qsb"
            }
        }
    }

    background: RoundedInEffect {
        id: bkground
        implicitWidth: orientation.vertical ? control.height : control.width
        implicitHeight: orientation.vertical ? control.width : control.height

        color: control.palette.button

        shadow {
            radius: width
            offset: 12
            spread: 30
            distance: 0.2
            angle: orientation.vertical ? 85 : 0
        }
    }
}
