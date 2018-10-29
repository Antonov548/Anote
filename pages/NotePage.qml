import QtQuick 2.11
import QtQuick.Controls 2.4

ScrollablePage{

    property string noteTitle: ""
    property string noteText: ""

    backgr: Rectangle{
        anchors.fill: parent
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
    }

    header: Rectangle{

        width: parent.width
        height: 50
        color: ApplicationSettings.isDarkTheme ? "#1B1B1B" : "white"
        visible: true

        Row{
            anchors.fill: parent
            spacing: 20
            padding: 0

            Button{
                id: button
                width: parent.height
                height: parent.height
                background: Rectangle{
                    anchors.fill: parent
                    color: ApplicationSettings.isDarkTheme ?  button.pressed ? "#292929" : "#1B1B1B" : button.pressed ? "#DEDEDE" : "white"
                    Rectangle{
                        height: 16
                        width: 2
                        color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 8; angle: 45}
                    }
                    Rectangle{
                        height: 16
                        width: 2
                        color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                        anchors.centerIn: parent
                        transform: Rotation { origin.x: 1; origin.y: 8; angle: 135}
                    }
                }
                onClicked: { stackView.pop()}
            }

            Label{
                text: "Запись"
                width: contentWidth
                height: parent.height
                color: ApplicationSettings.isDarkTheme ? "silver" : "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }
        }

        Rectangle{
            width: parent.width
            height: 1
            color: ApplicationSettings.isDarkTheme ? "silver" : "black"
            anchors.bottom: parent.bottom
            opacity: 0.2
        }
    }

    content: Column{
        anchors.fill: parent
        spacing: 20
        topPadding: 40

        Label{
            width: parent.width/1.2
            height: contentHeight
            wrapMode: Text.WordWrap
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: noteText
        }
    }
}
