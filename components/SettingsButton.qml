import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    property var onClicked: function(){}

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        onClicked: item.onClicked()

        Rectangle{
            width: mouseArea.pressed ? Math.max(item.height,item.width)+10 : 0
            height: mouseArea.pressed ? Math.max(item.height,item.width)+10 : 0
            color: "#F5F5F5"
            radius: height/2
            anchors.centerIn: parent

            Behavior on width{
                SequentialAnimation{
                    NumberAnimation{
                        duration: 400
                        easing.type: Easing.OutExpo
                    }
                }
            }
            Behavior on height{
                SequentialAnimation{
                    NumberAnimation{
                        duration: 400
                        easing.type: Easing.OutExpo
                    }
                }
            }
        }

        Rectangle{
            id: button
            anchors.centerIn: parent
            width: item.width - 5
            height: item.height - 5
            color: "transparent"

            Rectangle{
                x: (button.width - width)/2
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
            Rectangle{
                x: (button.width - width)/2
                y: (button.height - height)/2
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
            Rectangle{
                x: (button.width - width)/2
                y: button.height-height
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
        }
    }
}
