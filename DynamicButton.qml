import QtQuick
import QtQuick.Templates as T
import "Neumorphism/Base/"

// DynamicButton.qml

Item {
    AdvancedRectangle {
        width:  100
        height: 100

        property vector4d vec4: Qt.vector4d(0.5, 0.5, 0.5, 0.3)

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
    }
}
