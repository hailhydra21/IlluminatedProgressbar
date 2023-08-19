import QtQuick
import QtQuick.Window
import "Neumorphism/Base/"

Window {
    id: root
    width: 800
    height: 600
    visible: true
    title: qsTr("Neumorphism Illuminated ProgressBar Test(QML6.5)")

    color: "#e5f2fa"

    property bool running: false

    Column {
        anchors.centerIn: parent
        anchors.margins: 50
        spacing: 40

        Row {
            id: row
            spacing: 90

            Column {
                spacing: 10

                ProgressBar {
                    id: progress1
                    anchors.horizontalCenter: parent.horizontalCenter
                    glowVisable: value ? true : false

                    value: 0.16
                    color1: "#78d4d8"
                    color2: "#68b3f4"
                    edgeOffset1: {
                        return 0.35 - 0.47 * value
                    }

                    NumberAnimation on value {
                        to: 1.0
                        duration: 2000
                        running: root.running
                    }

                    NumberAnimation on value {
                        to: 0.16
                        duration: 2000
                        running: !root.running
                    }

                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#93a1ad"
                    font.pointSize: 13
                    //font.bold: true
                    text: qsTr("Relax")
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#6e8393"
                    font.pointSize: 11
                    font.bold: true
                    text: "%1%".arg(progress1.value.toFixed(2)*100)
                }
            }

            Column {
                spacing: 10

                Test {
                    id: progress4
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#93a1ad"
                    font.pointSize: 13
                    //font.bold: true
                    text: qsTr("Cardio")
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#6e8393"
                    font.pointSize: 11
                    font.bold: true
                    text: "%0"
                }
            }

            Column {
                spacing: 10

                ProgressBar {
                    id: progress2
                    anchors.horizontalCenter: parent.horizontalCenter
                    glowVisable: value ? true : false

                    value: 0.32
                    color1: "#f1a581"
                    color2: "#f2cd7e"
                    edgeOffset1: {
                        return 0.35 - 0.47 * value
                    }

                    NumberAnimation on value {
                        to: 0.8
                        duration: 2500
                        running: root.running
                    }

                    NumberAnimation on value {
                        to: 0.32
                        duration: 2500
                        running: !root.running
                    }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#93a1ad"
                    font.pointSize: 13
                    //font.bold: true
                    text: qsTr("Strength")
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#6e8393"
                    font.pointSize: 11
                    font.bold: true
                    text: "%1%".arg(progress2.value.toFixed(2)*100)
                }
            }

            Column {
                spacing: 10

                ProgressBar {
                    id: progress3
                    anchors.horizontalCenter: parent.horizontalCenter
                    glowVisable: value ? true : false

                    value: 0.64
                    color1: "#f676e2"
                    color2: "#fa8bab"
                    edgeOffset1: {
                        return 0.35 - 0.47 * value
                    }

                    NumberAnimation on value{
                        to: 0.16
                        duration: 3000
                        running: root.running
                    }

                    NumberAnimation on value {
                        to: 0.64
                        duration: 3000
                        running: !root.running
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#93a1ad"
                    font.pointSize: 13
                    //font.bold: true
                    text: qsTr("Stretch")
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#6e8393"
                    font.pointSize: 11
                    font.bold: true
                    text: "%1%".arg(progress3.value.toFixed(2)*100)
                }
            }
        }

        AdvancedRectangle {
            width:  100
            height: 100
            anchors.horizontalCenter: parent.horizontalCenter

            property vector4d vec4: Qt.vector4d(0.5, 0.5, 0.5, 0.3)

            // 8位颜色代码，aRGB
            color: "#553bbdf5"
            radius: vec4

            NumberAnimation on rotation { from: 0; to: 360; loops: -1; duration: 5000 }

            SequentialAnimation on vec4.x { loops: -1
                NumberAnimation { to: 0.5; duration: 1500 }
                NumberAnimation { to: 0.2; duration: 900 }
            }
            SequentialAnimation on vec4.y { loops: -1
                NumberAnimation { to: 0.5; duration: 700 }
                NumberAnimation { to: 0.3; duration: 2100 }
            }
            SequentialAnimation on vec4.z { loops: -1
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 0.4; duration: 1200 }
            }
            SequentialAnimation on vec4.w { loops: -1
                NumberAnimation { to: 0.5; duration: 700 }
                NumberAnimation { to: 0.3; duration: 5000 }
            }

            AdvancedRectangle {
                width:  parent.width
                height: parent.height

                property vector4d vec4: Qt.vector4d(0.3, 0.4, 0.4, 0.5)

                color: parent.color

                radius: vec4

                NumberAnimation on rotation { from: 180; to: -180; loops: -1; duration: 2500 }

                SequentialAnimation on vec4.x { loops: -1
                    NumberAnimation { to: 0.5; duration: 1000 }
                    NumberAnimation { to: 0.2; duration: 1000 }
                }
                SequentialAnimation on vec4.y { loops: -1
                    NumberAnimation { to: 0.5; duration: 700 }
                    NumberAnimation { to: 0.4; duration: 1100 }
                }
                SequentialAnimation on vec4.z { loops: -1
                    NumberAnimation { to: 0.5; duration: 1100 }
                    NumberAnimation { to: 0.3; duration: 1200 }
                }
                SequentialAnimation on vec4.w { loops: -1
                    NumberAnimation { to: 0.5; duration: 700 }
                    NumberAnimation { to: 0.3; duration: 6000 }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.running = !root.running
            }
        }
    }
}
