import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item{
    id: item

    width: parent.width - 16
    height: 50
    anchors.horizontalCenter: parent.horizontalCenter

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: item; property: "ListView.delayRemove"; value: true }
        PropertyAnimation {
            property: "opacity"
            target: item
            to: 0
            duration: 400
            easing.type: Easing.InOutQuad
        }
        PropertyAction { target: item; property: "ListView.delayRemove"; value: false }
    }

    Rectangle{
        anchors.fill: parent
        radius: 2
        clip: true

        color: ApplicationSettings.isDarkTheme ?  mouseArea.pressed ? "#292929" : "#323232" : mouseArea.pressed ? "#BFBFBF" : "#DEDEDE"

        Rectangle{
            width: parent.width
            height: 3
            color: ApplicationSettings.isDarkTheme ? "#272727" : "#EAEAEA"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row{
            anchors.fill: parent
            leftPadding: 10
            spacing: 10

            Label{
                text: model.info
                width: item.width/1.2
                height: item.height
                color: ApplicationSettings.isDarkTheme ? "silver" : "#454545"
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle{
                width: 28
                height: 28
                radius: 4
                color: "transparent"
                border.color: "#2D395B"
                border.width: 3
                anchors.verticalCenter: parent.verticalCenter

                Rectangle{
                    visible: !model.done
                    width: 26
                    height: 26
                    anchors.centerIn: parent
                    color: "#2D395B"

                    Rectangle{
                        width: 2
                        height: 20
                    }
                }
            }
        }
    }

    MouseArea{
        id: mouseArea

        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        hoverEnabled: true
    }
}
