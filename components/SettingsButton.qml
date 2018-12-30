import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: item
    property var onClicked: function(){}

    Button{
        id: button
        anchors.fill: parent
        padding: 0
        onClicked: item.onClicked()

        background: Rectangle{
            width: Math.max(item.height,item.width)+10
            height: Math.max(item.height,item.width)+10
            color: ApplicationSettings.isDarkTheme ? "#3F3F3F" : "#E4E4E4"
            radius: height/2
            anchors.centerIn: parent
            opacity: button.pressed ? 1 : 0
            Behavior on opacity {
                NumberAnimation{
                    duration: 500
                    easing.type: Easing.OutExpo
                }
            }
        }

        Rectangle{
            id: content_btn
            anchors.centerIn: parent
            width: item.width - 5
            height: item.height - 5
            color: "transparent"

            Rectangle{
                x: (content_btn.width - width)/2
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
            Rectangle{
                x: (content_btn.width - width)/2
                y: (content_btn.height - height)/2
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
            Rectangle{
                x: (content_btn.width - width)/2
                y: content_btn.height-height
                width: 4
                height: 4
                radius: 2
                color: ApplicationSettings.isDarkTheme ? "#D7D7D7" : "#444444"
            }
        }
    }
}
